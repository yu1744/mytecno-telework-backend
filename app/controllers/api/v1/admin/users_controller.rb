module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        before_action :set_user, only: [:update]

        # GET /api/v1/admin/users
        def index
          authorize([:admin, User])
          @users = User.all
          render json: @users
        end

        # PATCH /api/v1/admin/users/:id
        # PUT /api/v1/admin/users/:id
        def update
          authorize([:admin, @user])
          if @user.update(user_params)
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:name, :email, :role_id)
        end
      end
    end
  end
end