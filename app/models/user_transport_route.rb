class UserTransportRoute < ApplicationRecord
  belongs_to :user
  belongs_to :transport_route
end
