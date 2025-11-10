class ApprovalPolicy < ApplicationPolicy
  def index?
    user.approver? || user.admin?
  end

  def update?
    user.approver? || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end