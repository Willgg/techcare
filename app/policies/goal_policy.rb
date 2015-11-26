class GoalPolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
