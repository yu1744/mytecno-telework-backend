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
    false
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
      case user.role.name
      when 'admin'
        scope.all
      when 'approver'
        scope.joins(:user).where(users: { department_id: user.department_id })
      when 'applicant'
        scope.where(user: user)
      else
        scope.none
      end
    end

    private

    attr_reader :user, :scope
  end
end
