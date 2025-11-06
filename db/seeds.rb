# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 シードデータを作成中..."

# Create Application Statuses
puts "📝 申請ステータスを作成中..."
ApplicationStatus.find_or_create_by!(id: 1) { |s| s.name = '申請中' }
ApplicationStatus.find_or_create_by!(id: 2) { |s| s.name = '承認' }
ApplicationStatus.find_or_create_by!(id: 3) { |s| s.name = '却下' }
ApplicationStatus.find_or_create_by!(id: 4) { |s| s.name = '取り消し' }
puts "✅ 申請ステータス作成完了"

# Create Roles
puts "👥 ロールを作成中..."
admin_role = Role.find_or_create_by!(id: 1) { |r| r.name = 'admin' }
approver_role = Role.find_or_create_by!(id: 2) { |r| r.name = 'approver' }
user_role = Role.find_or_create_by!(id: 3) { |r| r.name = 'user' }
puts "✅ ロール作成完了"

# Create Departments
puts "🏢 部署を作成中..."
general_dept = Department.find_or_create_by!(id: 1) { |d| d.name = '総務部' }
dev_dept = Department.find_or_create_by!(id: 2) { |d| d.name = '開発部' }
sales_dept = Department.find_or_create_by!(id: 3) { |d| d.name = '営業部' }
hr_dept = Department.find_or_create_by!(id: 4) { |d| d.name = '人事部' }
puts "✅ 部署作成完了"

# Create Initial Users
puts "👤 初期ユーザーを作成中..."

# Admin User
admin = User.find_or_initialize_by(email: 'admin@example.com')
if admin.new_record?
  admin.assign_attributes(
    password: 'password123',
    password_confirmation: 'password123',
    name: '管理者',
    role: admin_role,
    department: general_dept,
    employee_number: 'A001'
  )
  admin.save!
  puts "✅ 管理者ユーザー作成: admin@example.com / password123"
else
  puts "⏭️  管理者ユーザーは既に存在します"
end

# Approver User
approver = User.find_or_initialize_by(email: 'approver@example.com')
if approver.new_record?
  approver.assign_attributes(
    password: 'password123',
    password_confirmation: 'password123',
    name: '承認者',
    role: approver_role,
    department: dev_dept,
    employee_number: 'M001'
  )
  approver.save!
  puts "✅ 承認者ユーザー作成: approver@example.com / password123"
else
  puts "⏭️  承認者ユーザーは既に存在します"
end

# Regular User
regular_user = User.find_or_initialize_by(email: 'user@example.com')
if regular_user.new_record?
  regular_user.assign_attributes(
    password: 'password123',
    password_confirmation: 'password123',
    name: '一般ユーザー',
    role: user_role,
    department: dev_dept,
    employee_number: 'U001',
    manager: approver
  )
  regular_user.save!
  puts "✅ 一般ユーザー作成: user@example.com / password123"
else
  puts "⏭️  一般ユーザーは既に存在します"
end

puts ""
puts "🎉 シードデータ作成完了！"
puts ""
puts "📋 ログイン情報:"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "管理者:"
puts "  Email: admin@example.com"
puts "  Password: password123"
puts ""
puts "承認者:"
puts "  Email: approver@example.com"
puts "  Password: password123"
puts ""
puts "一般ユーザー:"
puts "  Email: user@example.com"
puts "  Password: password123"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts ""

