module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        before_action :set_user, only: [:show, :update, :destroy]

        # GET /api/v1/admin/users
        def index
          authorize([:admin, User])
          @users = User.includes(:department, :role, :group)
          render json: @users.as_json(
            include: {
              department: { only: [:id, :name] },
              role: { only: [:id, :name] },
              group: { only: [:id, :name] }
            },
            methods: [:hired_date]
          )
        end

        # GET /api/v1/admin/users/:id
        def show
          authorize([:admin, @user])
          render json: @user.as_json(
            include: {
              department: { only: [:id, :name] },
              role: { only: [:id, :name] },
              group: { only: [:id, :name] }
            },
            methods: [:hired_date]
          )
        end

        # POST /api/v1/admin/users
        def create
          authorize([:admin, User])
          @user = User.new(user_params)
          if @user.save
            render json: @user.as_json(
              include: {
                department: { only: [:id, :name] },
                role: { only: [:id, :name] },
                group: { only: [:id, :name] }
              },
              methods: [:hired_date]
            ), status: :created
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/users/:id
        # PUT /api/v1/admin/users/:id
        def update
          authorize([:admin, @user])
          if @user.update(user_params)
            render json: @user.as_json(
              include: {
                department: { only: [:id, :name] },
                role: { only: [:id, :name] },
                group: { only: [:id, :name] }
              },
              methods: [:hired_date]
            )
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
            :manager_id,
            :hired_date,
            :group_id,
            :position,
            :is_caregiver,
            :has_child_under_elementary
          )
        end
      end
    end
  end
end