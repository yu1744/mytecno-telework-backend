class Api::V1::ApprovalsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    authorize :approval, :index?

    subordinate_ids = current_api_v1_user.subordinates.pluck(:id)
    
    applications = Application.includes(:user, :application_status)
                              .where(user_id: subordinate_ids, application_status_id: 1)
                              .order(date: :desc)

                              
    approval_data = Approval.joins(:application)
                            .where(applications: { user_id: subordinate_ids })
                            .where(comment: [nil, ""]) 
                            .pluck('applications.user_id', 'applications.date')

    weekly_approval_counts = approval_data.each_with_object(Hash.new(0)) do |(user_id, date), counts|
      week_start = date.beginning_of_week(:monday)
      counts[[user_id, week_start]] += 1
    end

    data = applications.map do |app|
      app_week_start = app.date.beginning_of_week(:monday)
      
      user_weekly_count = weekly_approval_counts[[app.user_id, app_week_start]].to_i

      {
        id: app.id,
        date: app.date,
        reason: app.reason,
        start_time: app.start_time,
        end_time: app.end_time,
        is_special_case: app.is_special_case,
        special_reason: app.special_reason,
        user: {
          name: app.user.name
        },
        application_status: {
          id: app.application_status.id,
          name: app.application_status.name
        },
        user_weekly_approval_count: user_weekly_count
      }
    end

    render json: data
  end

  def show
  end

 
  def create
  end


  def update
    authorize :approval, :update?

    application = Application.find(params[:id])
    status_name = params[:status] 
    comment = params[:comment]

    new_status_id = ApplicationStatus.find_by(name: status_name).id

    ActiveRecord::Base.transaction do
      application.update!(application_status_id: new_status_id)
      Approval.create!(
        application: application,
        approver_id: current_api_v1_user.id,
        comment: comment
      )
    end

    render json: { message: "Application #{status_name} successfully." }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Application not found.' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
  end
end
