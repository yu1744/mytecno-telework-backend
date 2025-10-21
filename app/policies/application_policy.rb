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
    false
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
        scope.where(user_id: User.where(department_id: user.department_id).pluck(:id))
      when 'applicant'
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end

    private

    attr_reader :user, :scope
  end
end
