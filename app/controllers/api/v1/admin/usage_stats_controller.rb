module Api
  module V1
    module Admin
      class UsageStatsController < ApplicationController
        before_action :authenticate_user!
        before_action :require_admin!

        def index
          stats = fetch_usage_stats

          render json: {
            total_users: stats[:total_users],
            users_by_department: stats[:users_per_department].map { |name, count| { name: name, count: count } },
            applications_by_type: stats[:applications_per_type].map { |type, count| { application_type: type, count: count } },
            applications_by_month: stats[:applications_per_month].map { |month, count| { month: month, count: count } },
            users_by_group: stats[:users_by_group]
          }
        end

        def export
          stats = fetch_usage_stats
          csv_data = generate_csv(stats)

          render json: { csv: csv_data }
        end

        private

        def fetch_usage_stats
          users_by_group = Group.joins(:users).group('groups.name').count.map do |name, count|
            { name: name, value: count }
          end

          {
            total_users: User.count,
            users_per_department: Department.joins(:users).group('departments.name').count,
            applications_per_type: Application.group(:work_option).count,
            applications_per_month: Application.group_by_month(:date, format: "%Y-%m").count,
            users_by_group: users_by_group
          }
        end

        def generate_csv(stats)
          require 'csv'

          CSV.generate(headers: true) do |csv|
            csv << ["項目", "値"]
            csv << []
            csv << ["総ユーザー数", stats[:total_users]]
            csv << []
            csv << ["部署ごとのユーザー数"]
            csv << ["部署名", "ユーザー数"]
            stats[:users_per_department].each do |dept, count|
              csv << [dept, count]
            end
            csv << []
            csv << ["申請種別ごとの申請数"]
            csv << ["申請種別", "申請数"]
            stats[:applications_per_type].each do |type, count|
              csv << [type, count]
            end
            csv << []
            csv << ["月別の申請数"]
            csv << ["年月", "申請数"]
            stats[:applications_per_month].each do |month, count|
              csv << [month, count]
            end
          end
        end

        def require_admin!
          render json: { error: 'Forbidden' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end