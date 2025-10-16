class UserInfoChange < ApplicationRecord
  belongs_to :user
  belongs_to :changer, class_name: 'User'
  belongs_to :new_department, class_name: 'Department', optional: true
  belongs_to :new_role, class_name: 'Role', optional: true
  belongs_to :new_manager, class_name: 'User', optional: true

  validates :effective_date, presence: true
  validates :status, presence: true, inclusion: { in: %w(pending processed canceled) }
end