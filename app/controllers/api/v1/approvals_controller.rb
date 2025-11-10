class Api::V1::ApprovalsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    authorize :approval, :index?

    subordinate_ids = current_api_v1_user.subordinates.pluck(:id)
    applications = Application.where(user_id: subordinate_ids, application_status_id: 1) 

    render json: applications, include: [:user, :application_status]
  end

  def show
  end

 
  def create
  end


  def update
    ##あ
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

