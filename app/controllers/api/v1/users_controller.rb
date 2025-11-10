class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    users = User.all.includes(:department, :role, :group)
    render json: users.as_json(include: [:department, :role, :group])
  end

  def show
    user = User.includes(:department, :role, :group, user_transport_routes: :transport_route).find(params[:id])
    render json: user.as_json(
      include: [
        :department,
        :role,
        :group,
        { user_transport_routes: { include: :transport_route } }
      ]
    )
  end

  def me
    user = User.includes(:department, :role, :group, user_transport_routes: :transport_route).find(current_api_v1_user.id)
    render json: user.as_json(
      include: [
        :department,
        :role,
        :group,
        { user_transport_routes: { include: :transport_route } }
      ]
    )
  end

  def application_limit
    user = User.find(params[:id])
    application_count = user.applications.where(created_at: Time.zone.now.all_month).count
    render json: { application_count: application_count }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation, :employee_number,
      :department_id, :role_id, :group_id, :position, :is_caregiver, :has_child_under_elementary
    )
  end
end
