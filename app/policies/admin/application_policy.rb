module Admin
  class ApplicationPolicy < ::ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.admin?
          scope.all
        elsif user.role.name == 'approver'
          if user.department
            scope.joins(:user).where(users: { department_id: user.department_id })
          else
            scope.none
          end
        else
          scope.none
        end
      end
    end

    def index?
      user.admin? || user.approver?
    end

    def export_csv?
      user.admin?
    end
  end
end