class Application < ApplicationRecord
  belongs_to :user
  belongs_to :application_status

  has_many :approvals

  # application_status_id: 1は「申請中」
  scope :pending, -> { where(application_status_id: 1) }

  validates :date, presence: true
  validates :work_option, presence: true, inclusion: { in: %w[full_day am_half pm_half] }
  validates :reason, presence: true, if: :is_special?
  validates :overtime_reason, presence: true, if: :is_overtime?
  validates :overtime_end, presence: true, if: :is_overtime?
end
