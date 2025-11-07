class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    @notifications = current_user.notifications.where(read: false).includes(:notifiable)
    render json: @notifications
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    if @notification.update(read: true)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end
end
