class Application < ApplicationRecord
  belongs_to :user
  belongs_to :application_status

  has_many :approvals

  validates :date, presence: true
  validates :work_option, presence: true, inclusion: { in: %w[full_day am_half pm_half] }
  validates :reason, presence: true, if: :is_special?
  validates :overtime_reason, presence: true, if: :is_overtime?
  validates :overtime_end, presence: true, if: :is_overtime?
end
