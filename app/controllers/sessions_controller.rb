class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token # !!!!!!ATTENTION vérifier cette manip avec un TA

  protected
  def after_sign_in_path_for(resource)
    if resource.is_adviser
      users_path # Or :prefix_to_your_route
    else
      Trainees::FetchMeasuresService.new(resource).fetch!
      user_goals_path(resource)
    end
  end
end
