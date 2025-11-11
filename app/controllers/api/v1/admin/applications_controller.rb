require 'csv'
module Api
  module V1
    module Admin
      class ApplicationsController < ApplicationController
        # GET /api/v1/admin/applications
        def index
          authorize([:admin, Application])
          @applications = Application.includes(:user, :application_status)

          # Filtering
          @applications = @applications.where(application_status_id: params[:status]) if params[:status].present?
          if params[:user_name].present?
            @applications = @applications.joins(:user).where("users.name LIKE ?", "%#{params[:user_name]}%")
          end

          # Sorting
          sort_column = params[:sort_by].in?(%w[created_at start_date end_date]) ? params[:sort_by] : 'created_at'
          sort_direction = params[:sort_order].in?(%w[asc desc]) ? params[:sort_order] : 'desc'
          @applications = @applications.order("#{sort_column} #{sort_direction}")

          render json: @applications, include: [:user, :application_status]
        end

        # GET /api/v1/admin/applications/export_csv
        def export_csv
          authorize([:admin, Application])
          @applications = Application.includes(:user, :application_status).all
          csv_data = CSV.generate(headers: true) do |csv|
            csv << ["申請ID", "申請者名", "申請日", "開始日", "終了日", "理由", "ステータス"]
            @applications.each do |app|
              csv << [
                app.id,
                app.user.name,
                app.created_at.strftime("%Y-%m-%d"),
                app.start_date,
                app.end_date,
                app.reason,
                app.application_status.name
              ]
            end
          end
          send_data csv_data, filename: "applications-#{Date.today}.csv"
        end
      end
    end
  end
end