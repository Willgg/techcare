class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(read_at: nil, recipient: user)
    end
  end
end
