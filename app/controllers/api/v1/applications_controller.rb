class Api::V1::ApplicationsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    applications = current_api_v1_user.applications.order(created_at: :desc)
    render json: applications
  end

  def show
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
  
  private
  
  def application_params
    params.require(:application).permit(:date, :reason, :work_option, :start_time, :end_time, :is_special, :is_overtime, :overtime_reason, :overtime_end)
  end

  def destroy
  end
end
