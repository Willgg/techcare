
class AuthorizationsController < ApplicationController

  require 'oauth2'
  require 'base64'
  before_action :find_provider, only: [:new, :create]
  skip_after_action :verify_authorized

  def new
    client         = OAuth2::Client.new(
                      ENV['FITBIT_CONSUMER_KEY'],
                      ENV['FITBIT_CONSUMER_SECRET'],
                      :site => 'https://www.fitbit.com')
    session[:locale] = params[:locale]
    url = client.auth_code.authorize_url(:redirect_uri => callback_url(@provider))
    url.gsub!(/oauth/, 'oauth2')
    redirect_to url + '&scope=activity%20sleep%20weight%20&expires_in=604800'
  end

  def create
    client      = OAuth2::Client.new( ENV['FITBIT_CONSUMER_KEY'],
                                      ENV['FITBIT_CONSUMER_SECRET'],
                                      :site => "https://api.fitbit.com" )
    ids_encoded = "Basic " + Base64::strict_encode64("#{client.id}:#{client.secret}")
    headers     = { 'Authorization' => ids_encoded,
                    'Content-Type' => 'application/x-www-form-urlencoded' }
    body        = { 'code' => params[:code],
                    'grant_type' => 'authorization_code',
                    'client_id' => client.id,
                    'redirect_uri' => callback_url(@provider),
                    'expires_in' => '31536000' }
    response = client.request(:post, 'https://api.fitbit.com/oauth2/token', :headers => headers, :body => body )
    access_token   = OAuth2::AccessToken.from_hash(client, response.parsed)
    @authorization = Authorization.new(
                       user: current_user,
                       token: access_token.token,
                       refresh_token: access_token.refresh_token,
                       source: params[:provider],
                       uid: access_token.params['user_id'])
    raise #TODEV
    options = { authorization: @authorization, locale: session[:locale] }

    # Fetch data from API and create Measures in database
    Trainees::FetchDataService.new(current_user, options).fetch!

    # Create goals for User
    Trainees::CreateGoalsService.new(current_user).call

    if @authorization.save
      flash[:notice] = I18n.t('controllers.authorizations.success', default: "Your data has been synchronized.")
      redirect_to user_goals_path(current_user)
    else
      flash[:alert] = I18n.t('controllers.authorizations.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end

  end

  def destroy
    #FIXME : todo
  end

  private

  def find_provider
    @provider = params[:provider]
  end

  def callback_url(provider)
    ENV['HOST'] + "/auth/#{provider}/callback"
  end

end
