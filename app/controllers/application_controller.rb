class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Uncomment these lines to get pundit
  # include Pundit
  # after_action :verify_authorized, except:  :index, unless: :devise_or_pages_or_admin_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_or_pages_or_admin_controller?
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # def after_sign_in_path_for(resource)
  #   raise
  #   if resource.persisted? && resource.first_name.blank?
  #     edit_user_registration_path
  #   else
  #     root_path
  #   end
  # end

  private

  def devise_or_pages_or_admin_controller?
    devise_controller? || pages_controller? || params[:controller] =~ /^admin/
  end

  def user_not_authorized
    flash[:error] = I18n.t('controllers.application.user_not_authorized', default: "You can't access this page.")
    redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :picture
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
    devise_parameter_sanitizer.for(:sign_up) << :birthday
    devise_parameter_sanitizer.for(:sign_up) << :sexe
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:picture, :first_name, :last_name) }
  end
end
