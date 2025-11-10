class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def profile
    user = User.find(params[:id])
    render json: {
      id: user.id,
      employee_number: user.employee_number,
      name: user.name,
      email: user.email,
      department: user.department.name,
      role: user.role.name,
      manager: user.manager&.name
    }
  end

  def application_limit
    user = User.find(params[:id])
    application_count = user.applications.where(created_at: Time.zone.now.all_month).count
    render json: { application_count: application_count }
  end
 
  def create
  end
 
  def update
  end
 
  def destroy
  end
end
