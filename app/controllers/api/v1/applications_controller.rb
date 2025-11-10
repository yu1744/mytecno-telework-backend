class Api::V1::ApplicationsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    Rails.logger.info "Current user role: #{current_api_v1_user.role.name}"
    @applications = policy_scope(Application).includes(user: :department).includes(:application_status)

    # Filtering
    if params[:filter_by_status].present?
      @applications = @applications.where(application_status_id: params[:filter_by_status])
    end
    if params[:filter_by_user].present? && current_api_v1_user.role.name == 'admin'
      @applications = @applications.where(user_id: params[:filter_by_user])
    end

    # Sorting
    sort_column = params[:sort_by].in?(%w[created_at date status]) ? params[:sort_by] : 'created_at'
    sort_direction = params[:sort_order].in?(%w[asc desc]) ? params[:sort_order] : 'desc'

    @applications = @applications.left_outer_joins(:application_status)

    order_clause = if sort_column == 'status'
                     "application_statuses.name #{sort_direction}"
                   else
                     "applications.#{sort_column} #{sort_direction}"
                   end
    @applications = @applications.order(Arel.sql(order_clause))

    render json: @applications.as_json(
      only: [:id, :reason, :created_at, :date, :application_status_id],
      include: {
        user: {
          only: [:name],
          include: {
            department: { only: [:name] }
          }
        },
        application_status: { only: [:name] }
      }
    )
  end

  def show
    @application = Application.includes(
      { user: :transport_routes },
      :application_status,
      { approvals: :approver }
    ).find(params[:id])
    authorize @application

    render json: @application.as_json(
      only: [
        :id, :date, :work_option, :start_time, :end_time, :reason,
        :is_overtime, :overtime_reason, :overtime_end, :project, :break_time
      ],
      include: {
        user: {
          only: [:id, :name],
          include: {
            transport_routes: { only: [:id, :name, :cost] }
          }
        },
        application_status: { only: [:id, :name] },
        approvals: {
          include: {
            approver: { only: [:id, :name] }
          },
          only: [:id, :status, :comment]
        }
      }
    )
  end

  def stats
    # ログインユーザーが申請した、または承認者として関わっている申請を取得
    applications = Application.where(user_id: current_api_v1_user.id).or(Application.where(id: Approval.where(approver_id: current_api_v1_user.id).select(:application_id)))
    
    # ステータスごとの件数を集計
    # 1: "申請中", 2: "承認", 3: "却下"
    stats = {
      pending: applications.where(application_status_id: 1).count,
      approved: applications.where(application_status_id: 2).count,
      rejected: applications.where(application_status_id: 3).count
    }
    
    render json: stats
  end

  def recent
    # ログインユーザーが申請した、または承認者として関わっている最新5件の申請を取得
    applications = Application.where(user_id: current_api_v1_user.id)
                               .or(Application.where(id: Approval.where(approver_id: current_api_v1_user.id).select(:application_id)))
                              .order(created_at: :desc)
                              .limit(5)
                              .includes(:user, :application_status)
    
    render json: applications.as_json(
      include: {
        user: { only: [:name] },
        application_status: { only: [:name] }
      }
    )
  end

  def calendar
    year = params[:year].to_i
    month = params[:month].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    applications = policy_scope(Application).where(date: start_date..end_date)
                                          .includes(:user, :application_status)

    calendar_data = applications.group_by { |a| a.date.to_s }
                                .transform_values do |apps|
      {
        pending: apps.count { |a| a.application_status.name == '申請中' },
        approved: apps.count { |a| a.application_status.name == '承認' },
        rejected: apps.count { |a| a.application_status.name == '却下' },
        total: apps.size,
        applications: apps.map do |app|
          {
            id: app.id,
            user_name: app.user.name,
            status: app.application_status.name
          }
        end
      }
    end

    render json: calendar_data
  end

  def create
    application = current_api_v1_user.applications.build(application_params)
    application.application_status_id = 1 # 1: "申請中"

    if application.save
      render json: application, status: :created
    else
      render json: application.errors, status: :unprocessable_entity
    end
  end

  def update
  end
  
  def destroy
    @application = Application.find_by(id: params[:id])
    if @application
      authorize @application
      # 4: "取り消し"
      if @application.update(application_status_id: 4)
        render json: { message: 'Application canceled successfully' }, status: :ok
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end
  
  private
  
  def application_params
    params.require(:application).permit(:date, :reason, :work_option, :start_time, :end_time, :is_special, :is_overtime, :overtime_reason, :overtime_end)
  end
end
