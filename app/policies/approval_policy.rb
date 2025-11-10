class ApprovalPolicy < ApplicationPolicy
  def index?
    user.approver? || user.admin?
  end

  def update?
    Rails.logger.info "=== Approval Policy Debug ==="
    Rails.logger.info "User role: #{user.role.name}"
    Rails.logger.info "User is approver?: #{user.approver?}"
    Rails.logger.info "User is admin?: #{user.admin?}"
    
    return false unless user.approver? || user.admin?
    
    # recordがapprovalの場合とapplicationの場合の両方に対応
    application = record.is_a?(Application) ? record : record.application
    return false if application.nil?
    
    application_user = application.user
    
    Rails.logger.info "Application user role: #{application_user.role.name}"
    Rails.logger.info "Application user is approver?: #{application_user.approver?}"
    Rails.logger.info "Application user is admin?: #{application_user.admin?}"
    
    # 承認者(approver)の申請は管理者(admin)が承認できる
    if application_user.approver?
      result = user.admin?
      Rails.logger.info "Application user is approver, checking if current user is admin: #{result}"
      return result
    end
    
    # 管理者(admin)の申請は、申請者とは別の管理者が承認できる
    if application_user.admin?
      result = user.admin? && user.id != application_user.id
      Rails.logger.info "Application user is admin, checking if current user is different admin: #{result}"
      return result
    end
    
    # 一般ユーザーの申請は承認者か管理者が承認できる
    result = user.approver? || user.admin?
    Rails.logger.info "Application user is general user, result: #{result}"
    result
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end