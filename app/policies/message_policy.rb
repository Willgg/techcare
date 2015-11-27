class MessagePolicy < ApplicationPolicy

  def create?
    true
  end

  def destroy?
    user == record.sender
  end

  def read
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
