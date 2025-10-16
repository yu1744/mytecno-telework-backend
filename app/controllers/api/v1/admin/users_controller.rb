module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        before_action :set_user, only: [:update, :destroy]

        # GET /api/v1/admin/users
        def index
          authorize([:admin, User])
          @users = User.includes(:department, :role)
          render json: @users, include: [:department, :role]
        end

        # POST /api/v1/admin/users
        def create
          authorize([:admin, User])
          @user = User.new(user_params)
          if @user.save
            render json: @user, status: :created
          else
            render json: @user.errors, status: :unprocessable_entity
          end
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

        # DELETE /api/v1/admin/users/:id
        def destroy
          authorize([:admin, @user])
          @user.destroy
          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(
            :name,
            :email,
            :password,
            :password_confirmation,
            :employee_number,
            :department_id,
            :role_id,
            :manager_id
          )
        end
      end
    end
  end
end