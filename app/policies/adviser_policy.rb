class AdviserPolicy < ApplicationPolicy

  def index?
    user.adviser.blank? && user.is_adviser != true
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
