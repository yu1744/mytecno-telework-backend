class Approval < ApplicationRecord
  belongs_to :application
  belongs_to :approver, class_name: 'User'
  validates :comment, presence: true, if: :rejected?

  def rejected?
    status == 'rejected'
  end
end
