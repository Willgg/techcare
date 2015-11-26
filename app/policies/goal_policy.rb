class GoalPolicy < ApplicationPolicy

  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end
end
