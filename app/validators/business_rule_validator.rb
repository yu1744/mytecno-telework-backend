# 業務ルール厳密化バリデーター
class BusinessRuleValidator < ActiveModel::Validator
  # 5:00-22:00 の時間帯チェック
  def validate_time_range(record)
    return unless record.start_time.present?

    start_hour = record.start_time.hour
    end_hour = record.overtime_end&.hour || 18 # デフォルトは18時

    if start_hour < 5
      record.errors.add(:start_time, '勤務開始時刻は5:00以降である必要があります')
    end

    if end_hour > 22
      record.errors.add(:overtime_end, '勤務終了時刻は22:00以前である必要があります')
    end
  end

  # 早朝利用（5:00-9:00開始）の承認チェック
  def validate_early_morning_approval(record)
    return unless record.start_time.present?

    start_hour = record.start_time.hour
    if start_hour >= 5 && start_hour < 9
      record.errors.add(:start_time, '早朝利用（5:00-9:00）には管理者の事前承認が必要です') unless record.early_morning_approved?
    end
  end

  # 8時間超過時の理由チェック
  def validate_overtime_reason_required(record)
    return unless record.work_hours_exceeded?

    if record.overtime_reason.blank?
      record.errors.add(:overtime_reason, '8時間を超える勤務には理由が必須です')
    end

    if record.overtime_end.blank?
      record.errors.add(:overtime_end, '8時間を超える勤務には終了時刻が必須です')
    end
  end

  def validate(record)
    validate_time_range(record)
    validate_early_morning_approval(record) unless record.skip_early_morning_check
    validate_overtime_reason_required(record)
  end
end
