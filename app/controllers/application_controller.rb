class ApplicationController < ActionController::API
  include Pundit::Authorization
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  end

  def pundit_user
    current_api_v1_user
  end
end
