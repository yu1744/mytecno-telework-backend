# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Departments
hr_department = Department.find_or_create_by!(name: '人事総務部')
dev_department = Department.find_or_create_by!(name: '開発部')

# Create Roles
admin_role = Role.find_or_create_by!(name: 'admin')
approver_role = Role.find_or_create_by!(name: 'approver')
applicant_role = Role.find_or_create_by!(name: 'applicant')

# Create Users
# Approver (Manager) for Development Department
approver = User.find_or_initialize_by(email: 'approver@example.com')
approver.update!(
  name: '承認 太郎',
  password: 'password',
  password_confirmation: 'password',
  department: dev_department,
  role: approver_role,
  hired_date: '2020-04-01',
  confirmed_at: Time.now
)

# Applicant in Development Department, subordinate of the approver
applicant = User.find_or_initialize_by(email: 'applicant@example.com')
applicant.update!(
  name: '申請 花子',
  password: 'password',
  password_confirmation: 'password',
  department: dev_department,
  role: applicant_role,
  hired_date: '2022-04-01',
  manager: approver,
  confirmed_at: Time.now
)

# Admin in HR Department
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.update!(
  name: '管理 者郎',
  password: 'password',
  password_confirmation: 'password',
  department: hr_department,
  role: admin_role,
  hired_date: '2018-04-01',
  confirmed_at: Time.now
)
