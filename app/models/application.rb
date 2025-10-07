class Application < ApplicationRecord
  belongs_to :user
  belongs_to :application_status

  has_many :approvals

  validates :date, presence: true
  validates :reason, presence: true
end
