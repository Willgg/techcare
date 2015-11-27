class GoalPolicy < ApplicationPolicy
  attr_reader :user, :user_param, :record

  def initialize(user, user_param, record)
    @user = user
    @record = record
    @user_param = user_param
  end

  def index?
    user == user_param || user.coach == user_param.adviser
  end

  def create?
    user.is_adviser && user.coach == user_param.adviser
  end

  def destroy?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
