class GoalPolicy < ApplicationPolicy
  attr_reader :user, :user_param, :record

  def initialize(user, user_param, record)
    @user = user
    @record = record
    @user_param = user_param
  end

  def index?
    if user.is_adviser
      user_param.adviser == user.coach
    else
      user == user_param &&
      user.subscription.present? && user.subscription.active &&
      user.adviser.present?
    end
  end

  def create?
    user.is_adviser && ( user.coach == user_param.adviser )
  end

  def destroy?
    user.is_adviser && ( user.coach == user_param.adviser )
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
