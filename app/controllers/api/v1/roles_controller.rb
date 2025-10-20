class Api::V1::RolesController < ApplicationController
  def index
    @roles = Role.all
    render json: @roles
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
