class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :role
  belongs_to :department

  has_many :applications
  has_many :approvals, foreign_key: :approver_id

  belongs_to :manager, class_name: 'User', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'

  has_many :user_transport_routes
  has_many :transport_routes, through: :user_transport_routes

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
end
