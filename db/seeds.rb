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

# テストユーザーの作成
puts "👤 テストユーザーを作成中..."

users_data = [
  # 代表
  { employee_number: 'T36837', last_name: '鈴木', first_name: '美咲', department: '直属', group: nil, position: '代表取締役会長', hired_date: '1995-04-01' },
  { employee_number: 'T36858', last_name: '渡辺', first_name: '大輔', department: '直属', group: nil, position: '代表取締役社長', hired_date: '1995-04-01' },
  # 部長
  { employee_number: 'T36830', last_name: '佐藤', first_name: '健', department: '人事総務部', group: nil, position: '部長', hired_date: '1995-04-01' },
  { employee_number: 'T36851', last_name: '田中', first_name: '優子', department: 'ホールセールシステム開発部', group: nil, position: '部長', hired_date: '1995-04-01' },
  # グループリーダー
  { employee_number: 'T36879', last_name: '中村', first_name: '直美', department: '人事総務部', group: '人事グループ', position: 'グループリーダー', hired_date: '1995-04-01' },
  { employee_number: 'T36886', last_name: '小林', first_name: '真一', department: 'リテールシステム開発部', group: '契約管理システムグループ', position: 'グループリーダー', hired_date: '1995-09-01' },
  # チーフ
  { employee_number: 'T36875', last_name: '林', first_name: '優斗', department: 'システム開発推進部', group: 'オープン開発グループ', position: 'チーフ', hired_date: '1995-04-01' },
  { employee_number: 'T36893', last_name: '加藤', first_name: '美香', department: 'システム開発推進部', group: '青森開発グループ', position: 'チーフ', hired_date: '1995-09-01' },
  # 一般
  { employee_number: 'T36882', last_name: '清水', first_name: '由美', department: 'システム開発推進部', group: 'ホスト開発グループ', position: nil, hired_date: '1995-04-01' },
  { employee_number: 'T36900', last_name: '吉田', first_name: '健二', department: '人事総務部', group: '採用教育グループ', position: nil, hired_date: '1995-12-03' },
]

users_data.each do |user_data|
  department = Department.find_or_create_by!(name: user_data[:department])
  
  group = nil
  if user_data[:group]
    group = Group.find_or_create_by!(name: user_data[:group], department: department)
  end

  user = User.find_or_initialize_by(employee_number: user_data[:employee_number])
  if user.new_record?
    user.assign_attributes(
      name: "#{user_data[:last_name]} #{user_data[:first_name]}",
      email: "#{user_data[:employee_number].downcase}@example.com",
      password: 'password',
      password_confirmation: 'password',
      department: department,
      group: group,
      position: user_data[:position],
      hired_date: user_data[:hired_date],
      is_caregiver: false,
      has_child_under_elementary: false,
      role: user_role # 全員userロールを付与
    )
    user.save!
    puts "✅ ユーザー作成: #{user.name}"
  else
    puts "⏭️  ユーザーは既に存在します: #{user.name}"
  end
end

# Create Applications and Approvals for test users
puts "📝 申請・承認データを作成中..."

# 承認者を取得
approver1 = User.find_by(employee_number: 'T36879') # 中村 直美
approver2 = User.find_by(employee_number: 'T36886') # 小林 真一

# 申請者を取得
applicant1 = User.find_by(employee_number: 'T36882') # 清水 由美
applicant2 = User.find_by(employee_number: 'T36900') # 吉田 健二
applicant3 = User.find_by(employee_number: 'T36875') # 林 優斗

# 申請ステータスを取得
status_pending = ApplicationStatus.find(1)
status_approved = ApplicationStatus.find(2)
status_rejected = ApplicationStatus.find(3)

# データ作成
application_data = [
  # --- applicant1 (清水 由美) の申請 ---
  # 過去の承認済み申請 (終日)
  { user: applicant1, approver: approver1, status: status_approved, date: 10.days.ago, work_option: 'full_day', reason: '私用のため', comment: '承認します。' },
  # 未来の申請中申請 (AM半休)
  { user: applicant1, approver: approver1, status: status_pending, date: 5.days.from_now, work_option: 'am_half', reason: '通院のため' },
  # 過去の却下された申請 (PM半休)
  { user: applicant1, approver: approver1, status: status_rejected, date: 3.days.ago, work_option: 'pm_half', reason: '急な私用', comment: '業務都合により却下します。' },

  # --- applicant2 (吉田 健二) の申請 ---
  # 未来の承認済み申請 (終日)
  { user: applicant2, approver: approver2, status: status_approved, date: 1.month.from_now, work_option: 'full_day', reason: '家族旅行', comment: '楽しんできてください。' },
  # 今日の申請中申請 (PM半休)
  { user: applicant2, approver: approver2, status: status_pending, date: Date.today, work_option: 'pm_half', reason: '役所手続き' },

  # --- applicant3 (林 優斗) の申請 ---
  # 過去の申請中申請 (AM半休)
  { user: applicant3, approver: approver1, status: status_pending, date: 1.week.ago, work_option: 'am_half', reason: '子供の学校行事' },
  # 未来の承認済み申請 (終日)
  { user: applicant3, approver: approver2, status: status_approved, date: 2.weeks.from_now, work_option: 'full_day', reason: 'リフレッシュ休暇', comment: '承知しました。' }
]

application_data.each do |data|
  app = Application.create!(
    user: data[:user],
    application_status: data[:status],
    date: data[:date],
    work_option: data[:work_option],
    reason: data[:reason]
  )

  Approval.create!(
    application: app,
    approver: data[:approver],
    status: data[:status].name, # '申請中', '承認', '却下'
    comment: data[:comment]
  )
end

puts "✅ 申請・承認データ作成完了"
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

