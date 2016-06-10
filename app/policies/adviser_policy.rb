class AdviserPolicy < ApplicationPolicy

  def index?
    user.is_trainee? && user.adviser.blank?
  end

  def create?
    user.adviser.blank?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
