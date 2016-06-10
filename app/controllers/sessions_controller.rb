class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token # ATTENTION: vérifier cette manip avec un TA

  protected
  def after_sign_in_path_for(resource)
    if resource.is_adviser
      users_path # Or :prefix_to_your_route
    else
      # Update Withings DataSet
      Trainees::FetchMeasuresService.new(resource).fetch! if resource.api_user_id

      # Update Providers DataSet
      if resource.authorizations
        options = {locale: params[:locale]}
        Trainees::FetchDataService.new(resource, options).update!
      end

      # Redirect user
      resource.adviser.present? ? user_goals_path(resource) : advisers_path
    end
  end
end
