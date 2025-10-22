module Admin
  class ApplicationPolicy < ::ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
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