class ProvidersController < ApplicationController
  require 'withings-api'
  require 'withings'
  require 'fitgem'

  include Withings
  include Withings::Api

  skip_after_action :verify_authorized, only: [:index, :create, :save_token]
  skip_after_action :verify_policy_scoped, only: :index

  def index
  end

  def create
    callback_url   = ENV['HOST'] + providers_callback_path
    consumer_token = ConsumerToken.new(
                      ENV['WITHINGS_OAUTH_CONSUMER_KEY'],
                      ENV['WITHINGS_OAUTH_CONSUMER_SECRET']
                      )
    request_token_response = Withings::Api.create_request_token(consumer_token, callback_url)
    request_token          = request_token_response.request_token

    current_user.api_consumer_key = request_token.key
    current_user.api_consumer_secret = request_token.secret
    current_user.save

    # Redirection to withings page for techcare autorization
    redirect_to request_token_response.authorization_url
  end

  def save_token

    # Settings request_token and consumer_token
    callback_url    = ENV['HOST'] + providers_callback_path
    request_token   = Withings::Api::RequestToken.new(current_user.api_consumer_key , current_user.api_consumer_secret)
    consumer_key    = ENV['WITHINGS_OAUTH_CONSUMER_KEY']
    consumer_secret = ENV['WITHINGS_OAUTH_CONSUMER_SECRET']
    consumer_token  = ConsumerToken.new( consumer_key, consumer_secret )

    # Get access tokens
    access_token_response = Withings::Api.create_access_token(request_token, consumer_token, "user_id_not_currently_required_by_withings")
    access_token          = access_token_response.access_token
    user_id               = access_token_response.user_id
    oauth_token           = access_token.key
    oauth_token_secret    = access_token.secret

    # Persisting access tokens in existing User
    current_user.api_consumer_key = oauth_token
    current_user.api_consumer_secret = oauth_token_secret
    current_user.api_user_id = params[:userid]
    current_user.save

    # Persisiting as a new Authorization
    auth = Authorization.new(source: 'withings',
                             uid: params[:userid],
                             token: oauth_token,
                             secret: oauth_token_secret,
                             user_id: current_user.id)
    auth.save

    # User data fetching
    Trainees::FetchMeasuresService.new(current_user).fetch!

    # Default Goals Creation
    Trainees::CreateGoalsService.new(current_user).call

    # Redirection to dashboard
    if !current_user.is_adviser && current_user.measures.exists?
      flash[:notice] = I18n.t('controllers.providers.success', default: "Your data has been synchronized.")
      redirect_to user_goals_path(current_user)
    else
      flash[:alert] = I18n.t('controllers.providers.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end
  end

end
