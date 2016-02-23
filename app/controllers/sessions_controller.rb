class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token # ATTENTION: vérifier cette manip avec un TA

  protected
  def after_sign_in_path_for(resource)
    if resource.is_adviser
      users_path # Or :prefix_to_your_route
    else
      if resource.api_user_id
        Trainees::FetchMeasuresService.new(resource).fetch!
      end
      if resource.authorizations
        options = {locale: params[:locale]}
        Trainees::FetchDataService.new(resource, options).update!
      end
      user_goals_path(resource)
    end
  end
end
