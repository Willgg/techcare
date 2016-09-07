class SubscriptionPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    record.user = user
  end

  def update?
    record.user = user
  end

  def destroy?
    record.user = user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
