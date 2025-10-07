class Api::V1::UserTransportRoutesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    render json: { message: "Not Implemented" }, status: :not_implemented
  end

  def create
    render json: { message: "Not Implemented" }, status: :not_implemented
  end

  def destroy
    render json: { message: "Not Implemented" }, status: :not_implemented
  end
end