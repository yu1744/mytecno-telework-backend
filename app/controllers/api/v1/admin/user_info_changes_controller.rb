module Api
  module V1
    module Admin
      class UserInfoChangesController < ApplicationController
        # GET /api/v1/admin/user_info_changes
        def index
          # authorize([:admin, UserInfoChange]) # punditでの認可を後で追加
          @user_info_changes = UserInfoChange.all
          render json: @user_info_changes
        end
      end
    end
  end
end