class AdvisersController < ApplicationController
  def index
    @advisers = policy_scope(Adviser)
    authorize @advisers
  end

  def user_not_authorized
    flash[:alert] = I18n.t('controllers.adviser.user_not_authorized', default: "You already have a coach.")
    redirect_to user_goals_path(current_user)
  end
end
