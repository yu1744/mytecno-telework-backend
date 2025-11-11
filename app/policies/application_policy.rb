# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    user.role.name == 'admin' ? false : user == record.user
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      Rails.logger.info "ApplicationPolicy::Scope resolving for user: #{user.id}, role: #{user.role.name}"
      case user.role.name
      when 'admin'
        Rails.logger.info 'Applying admin scope'
        scope.all
      when 'approver'
        Rails.logger.info 'Applying approver scope'
        scope.joins(:user).where(users: { department_id: user.department_id })
      when 'applicant'
        Rails.logger.info 'Applying applicant scope'
        scope.where(user: user)
      else
        Rails.logger.info 'Applying default scope (none)'
        scope.none
      end
    end

    private

    attr_reader :user, :scope
  end
end
