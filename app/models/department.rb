class Department < ApplicationRecord
  has_many :groups
  has_many :users
end
