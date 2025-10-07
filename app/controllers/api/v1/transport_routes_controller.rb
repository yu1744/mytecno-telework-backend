class Api::V1::TransportRoutesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    # 将来的にここで路線情報を外部APIから取得する
    render json: { message: "Not Implemented" }, status: :not_implemented
  end
end
