module Admin
  class ApplicationPolicy < ::ApplicationPolicy
    def index?
      user.admin?
    end

    def export_csv?
      user.admin?
    end
  end
end