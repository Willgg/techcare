class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  after_action :flash_to_headers
  after_action :verify_authorized, except: :index, unless: :devise_or_admin_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_or_admin_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def flash_to_headers
    return unless request.xhr?
    # x_message = flash_message.gsub("ê","&ecirc;").gsub("é","&eacute;").gsub("è","&egrave;")
    # response.headers['X-Message'] = x_message
    # response.headers["X-Message-Type"] = flash_type.to_s
    flash.discard
  end

  private

  def devise_or_admin_controller?
    devise_controller? || params[:controller] =~ /^admin/
  end

  def user_not_authorized
    if current_user.is_adviser?
      redirect_to(users_path)
    elsif !Subscription.exists?(user: current_user, active: true)
      flash[:notice] = I18n.t('controllers.application.sub_required')
      redirect_to(subscriptions_path)
    elsif !current_user.adviser.present?
      flash[:alert] = I18n.t('controllers.application.adviser_required')
      redirect_to(advisers_path(current_user))
    else
      flash[:alert] = I18n.t('controllers.application.user_not_authorized', default: "Sorry, you can't access this page.")
      redirect_to root_path
    end
  end

  # def flash_message
  #   [:error, :alert, :notice].each do |type|
  #     return flash[type] unless flash[type].blank?
  #   end
  #   return ''
  # end

  # def flash_type
  #   [:error, :alert, :notice].each do |type|
  #     return type unless flash[type].blank?
  #   end
  #   return :empty
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :picture
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
    devise_parameter_sanitizer.for(:sign_up) << :birthday
    devise_parameter_sanitizer.for(:sign_up) << :sexe
    devise_parameter_sanitizer.for(:sign_up) << :height
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :picture, :first_name, :last_name, :height, :password, :password_confirmation, :current_password) }
  end
end
