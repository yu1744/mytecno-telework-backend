class Api::V1::DepartmentsController < ApplicationController
  def index
    @departments = Department.all
    render json: @departments
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
