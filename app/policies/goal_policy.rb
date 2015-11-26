class GoalPolicy < ApplicationPolicy

  def index?
    raise
    user.id == params[:user_id]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
