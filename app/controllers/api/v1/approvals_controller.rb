class Api::V1::ApprovalsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    authorize :approval, :index?

    applications =
      if current_api_v1_user.role.name == 'admin'
        Application.pending
      elsif current_api_v1_user.role.name == 'approver'
        department_id = current_api_v1_user.department_id
        user_ids = User.where(department_id: department_id).pluck(:id)
        Application.pending.where(user_id: user_ids)
      else
        []
      end

    render json: applications, include: %i[user application_status]
  end

  def show
  end

  def create
  end

  def update
    @approval = Approval.find(params[:id])
    authorize @approval

    status = params[:status] # "approved" or "rejected"
    
    unless %w[approved rejected].include?(status)
      return render json: { error: 'Invalid status' }, status: :bad_request
    end

    ActiveRecord::Base.transaction do
      @approval.update!(status: status, approver_id: current_api_v1_user.id, comment: params[:comment])
      
      new_status_name = (status == 'approved') ? 'approved' : 'rejected'
      application_status = ApplicationStatus.find_by!(name: new_status_name)
      @approval.application.update!(application_status: application_status)
    end

    render json: { message: "Application #{status} successfully." }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Record not found.' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
  end
end
