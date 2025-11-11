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

  validate :validate_application_limit, on: :create

  def approvable_by?(user)
    # 申請者自身は承認できない
    return false if user == self.user

    # 管理者は常に承認できる
    return true if user.admin?

    # 承認者の条件をすべて満たすかチェック
    user.approver? &&
      user.department == self.user.department &&
      self.user.approver == user
  end

  def application_type
    case work_option
    when 'full_day'
      '在宅勤務申請（終日）'
    when 'am_half'
      '在宅勤務申請（午前半休）'
    when 'pm_half'
      '在宅勤務申請（午後半休）'
    else
      '在宅勤務申請'
    end
  end

  private

  def validate_application_limit
    return unless user && date

    # 育児・介護対象者の場合、月間上限をチェック
    if user.is_caregiver? || user.has_child_under_elementary?
      start_of_month = date.beginning_of_month
      end_of_month = date.end_of_month
      monthly_applications = user.applications.where(date: start_of_month..end_of_month)

      monthly_application_count = monthly_applications.reduce(0) do |sum, app|
        sum + (app.work_option == 'full_day' ? 1 : 0.5)
      end

      if monthly_application_count >= 10
        errors.add(:base, '月間の申請上限を超えています。')
        return # 月間上限に達していれば週の上限チェックは不要
      end
    end

    # 週の申請上限チェック（全ユーザー共通）
    start_of_week = date.beginning_of_week(:monday)
    end_of_week = date.end_of_week(:monday)
    weekly_applications = user.applications.where(date: start_of_week..end_of_week)

    limit = if user.years_of_service >= 3
              2
            else
              1
            end

    weekly_application_count = weekly_applications.reduce(0) do |sum, app|
      sum + (app.work_option == 'full_day' ? 1 : 0.5)
    end

    errors.add(:base, '週の申請上限を超えています。') if weekly_application_count >= limit
  end
end
