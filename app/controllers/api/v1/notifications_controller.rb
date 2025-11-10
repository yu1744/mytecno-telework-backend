class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    notifications = current_api_v1_user.notifications.where(read: false).includes(:notifiable)
    @notifications = notifications.select do |n|
      if n.notifiable.nil?
        Rails.logger.warn "Notification #{n.id} has a nil notifiable object. Notifiable type: #{n.notifiable_type}, Notifiable ID: #{n.notifiable_id}"
        false
      else
        true
      end
    end
    render json: @notifications
  end

  def update
    @notification = current_api_v1_user.notifications.find(params[:id])
    if @notification.update(read: true)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end
end
