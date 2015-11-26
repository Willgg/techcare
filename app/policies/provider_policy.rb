class ProviderPolicy < ApplicationPolicy

  def create?
    user.api_user_id.blank?
  end

end
