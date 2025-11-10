class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
  end

  def show
    user = current_api_v1_user
    render json: {
      id: user.id,
      name: user.name,
      email: user.email,
      employee_number: user.employee_number,
      department: user.department,
      role: user.role,
      user_transport_routes: user.user_transport_routes.includes(:transport_route).map do |utr|
        {
          id: utr.id,
          transport_route: utr.transport_route,
          cost: utr.cost
        }
      end
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
