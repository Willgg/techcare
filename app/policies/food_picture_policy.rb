class FoodPicturePolicy < ApplicationPolicy

  def create?
    !user.is_adviser
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
