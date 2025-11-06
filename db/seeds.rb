# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Application Statuses
ApplicationStatus.find_or_create_by!(id: 1) { |s| s.name = '申請中' }
ApplicationStatus.find_or_create_by!(id: 2) { |s| s.name = '承認' }
ApplicationStatus.find_or_create_by!(id: 3) { |s| s.name = '却下' }
ApplicationStatus.find_or_create_by!(id: 4) { |s| s.name = '取り消し' }

