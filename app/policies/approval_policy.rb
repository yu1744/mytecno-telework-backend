class ApprovalPolicy < ApplicationPolicy
  def index?
    user.approver? || user.admin?
  end

  def update?
    return false unless user.approver? || user.admin?
    
    application_user = record.application.user
    
    # 承認者(approver)の申請は管理者(admin)が承認できる
    if application_user.approver?
      return user.admin?
    end
    
    # 管理者(admin)の申請は、申請者とは別の管理者が承認できる
    if application_user.admin?
      return user.admin? && user.id != application_user.id
    end
    
    # 一般ユーザーの申請は承認者か管理者が承認できる
    user.approver? || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end