class AdvisersController < ApplicationController
  def index
    @advisers = policy_scope(Adviser)
    authorize @advisers
  end

  def user_not_authorized

    if current_user.is_adviser?
      flash[:alert] = I18n.t('controllers.adviser.coach_not_authorized', default: "You can't select a coach.")
      redirect_to users_path
    else
      flash[:alert] = I18n.t('controllers.adviser.user_has_coach', default: "You already have a coach.")
      redirect_to user_goals_path(current_user)
    end
  end
end
