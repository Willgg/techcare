module Advisers
  class SelectionsController < ApplicationController
    def create
      @adviser = Adviser.find(params[:adviser_id])
      authorize @adviser
      if current_user.update(adviser: @adviser)
        flash[:notice] = I18n.t('controllers.selection.adviser_selected', default: "Adviser has been successfully selected !")
        current_user.notify_coach(@adviser.user)
        redirect_to providers_path
      else
        flash[:alert] = I18n.t('controllers.selection.adviser_error', default: "Unable to select this adviser !")
        redirect_to advisers_path
      end
    end
  end
end
