class Approval < ApplicationRecord
  belongs_to :application
  belongs_to :approver, class_name: 'User'
end
