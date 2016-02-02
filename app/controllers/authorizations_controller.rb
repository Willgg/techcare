class AuthorizationsController < ApplicationController
  require 'oauth'
  include OAuth

  before_action :find_provider, only: [:new, :create]
  skip_after_action :verify_authorized

  def new
    callback_url   = ENV['HOST'] + "/auth/#{@provider}/callback"
    consumer       = OAuth::Consumer.new(
                      ENV['FITBIT_CONSUMER_KEY'],
                      ENV['FITBIT_CONSUMER_SECRET'],
                      :site => "https://api.fitbit.com")
    request_token  = consumer.get_request_token
    session[:request_token] = { token: request_token.token, secret: request_token.secret}
    session[:request_token_params] = request_token.params
    session[:locale] = params[:locale]

    redirect_to request_token.authorize_url
  end

  def create

    # Rebuild the Consumer
    consumer       = OAuth::Consumer.new(
                      ENV['FITBIT_CONSUMER_KEY'],
                      ENV['FITBIT_CONSUMER_SECRET'],
                      :site => "https://api.fitbit.com")

    # Rebuild the RequestToken from user's session
    request_token  = OAuth::RequestToken.from_hash(consumer, {oauth_token: session[:request_token]["token"], oauth_token_secret: session[:request_token]["secret"]})

    access_token   = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    uid            = access_token.params.select { |k,v| k.to_s.match(/user|id|uid/) }

    @authorization = Authorization.new(
                      user: current_user,
                      token: access_token.token,
                      secret: access_token.secret,
                      source: params[:provider],
                      uid: uid.values.last
                    )

    options = { authorization: @authorization, locale: session[:locale] }

    # Fetch data from API and create Measures in database
    Trainees::FetchDataService.new(current_user, options).fetch!

    # Create goals for User
    Trainees::CreateGoalsService.new(current_user).call

    if @authorization.save
      flash[:notice] = I18n.t('controllers.providers.success', default: "Your data has been synchronized.")
      redirect_to user_goals_path(current_user)
    else
      flash[:alert] = I18n.t('controllers.providers.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end

  end

  def destroy
    #FIXME : to do
  end

  private

  def find_provider
    @provider = params[:provider]
  end


end
