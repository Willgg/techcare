class AuthorizationsController < ApplicationController
  require 'oauth'
  include OAuth

  before_action :find_provider, only: [:create, :save_token]
  skip_after_action :verify_authorized

  def create
    @callback_url = ENV['HOST'] + "/auth/#{@provider}/callback"
    @consumer = OAuth::Consumer.new(ENV['FITBIT_CONSUMER_KEY'],ENV['FITBIT_CONSUMER_SECRET'], :site => "https://api.fitbit.com")
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    # session[:request_token] = @request_token

    # Create an new Authorization
    @authorization = Authorization.new(
                      token: @request_token.token,
                      secret: @request_token.secret,
                      user: current_user,
                      source: @provider
                    )
    if @authorization.save
      redirect_to @request_token.authorize_url(oauth_callback: @callback_url)
    else
      flash[:alert] = I18n.t('controllers.providers.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end
  end

  def save_token

    # Get back token and secret
    oauth_verifier = params[:oauth_verifier]
    @token          = params[:oauth_token]
    @authorization  = Authorization.where(token: @token, user: current_user).last
    @secret         = @authorization.secret

    # Rebuild the Consumer
    @consumer = OAuth::Consumer.new(ENV['FITBIT_CONSUMER_KEY'],ENV['FITBIT_CONSUMER_SECRET'], :site => "https://fitbit.com")

    # Rebuild the RequestToken
    @request_token = OAuth::RequestToken.new(@consumer, @token, @secret)

    # Add oauth_verifier in #get_access_token
    @access_token = @request_token.get_access_token(:oauth_verifier => oauth_verifier)
    raise
  end

  def destroy
  end

  private

  def find_provider
    @provider = params[:provider]
  end

end
