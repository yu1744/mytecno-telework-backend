class TransportRoute < ApplicationRecord
  has_many :user_transport_routes
  has_many :users, through: :user_transport_routes
end
