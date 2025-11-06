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
