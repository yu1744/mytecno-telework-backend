class ApprovalPolicy < ApplicationPolicy
  def index?
    user.approver?
  end

  def update?
    user.approver?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end