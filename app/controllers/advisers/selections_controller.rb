module Advisers
  class SelectionsController < ApplicationController
    def create
      @adviser = Adviser.find(params[:adviser_id])

      if current_user.update(adviser: @adviser)
        flash[:notice] = "Adviser successfully selected"
        redirect_to user_goals_path(current_user)
      else
        flash[:alert] = "Unable to select adviser"
        redirect_to advisers_path
      end
    end
  end
end
