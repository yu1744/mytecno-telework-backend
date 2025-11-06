class Api::V1::ApplicationsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    @applications = policy_scope(Application).includes(:user)
    render json: @applications.as_json(
      only: [:id, :reason, :created_at, :application_status_id, :date],
      include: { user: { only: [:name] } }
    )
  end

  def show
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
