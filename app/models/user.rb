class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :role
  belongs_to :department
  belongs_to :group, optional: true
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'approver_id'

  has_many :applications
  has_many :approvals, foreign_key: :approver_id
  has_many :notifications, dependent: :destroy

  belongs_to :manager, class_name: 'User', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'

  has_many :user_transport_routes
  has_many :transport_routes, through: :user_transport_routes

  has_many :push_subscriptions, dependent: :destroy

  def token_validation_response
    as_json(include: :role)
  end

  def role_name
    role&.name
  end

  def approver?
    role_name == 'approver'
  end

  def admin?
    role_name == 'admin'
  end

  def years_of_service
    return 0 unless hired_date

    (Date.current - hired_date).to_i / 365
  end
end
