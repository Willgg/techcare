class AuthorizationsController < ApplicationController
  require 'oauth'
  include OAuth

  before_action :find_provider, only: [:create, :save_token]
  skip_after_action :verify_authorized

  def create
    @callback_url   = ENV['HOST'] + "/auth/#{@provider}/callback"
    @consumer       = OAuth::Consumer.new(
                      ENV['FITBIT_CONSUMER_KEY'],
                      ENV['FITBIT_CONSUMER_SECRET'],
                      :site => "https://api.fitbit.com")
    @request_token  = @consumer.get_request_token(:oauth_callback => @callback_url)

    # Create an new Authorization
    @authorization = Authorization.new(
                      token:  @request_token.token,
                      secret: @request_token.secret,
                      user:   current_user,
                      source: @provider
                    )
    session[:request_token_params] = @request_token.params

    if @authorization.save
      redirect_to @request_token.authorize_url(oauth_callback: @callback_url)
    else
      flash[:alert] = I18n.t('controllers.providers.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end
  end

  def save_token

    # Get back token and secret
    @token          = params[:oauth_token]
    @authorization  = Authorization.where(token: @token, user: current_user).last
    @secret         = @authorization.secret

    # Rebuild the Consumer
    @consumer       = OAuth::Consumer.new(ENV['FITBIT_CONSUMER_KEY'],ENV['FITBIT_CONSUMER_SECRET'], :site => "https://fitbit.com")

    # Rebuild the RequestToken
    @request_token = OAuth::RequestToken.new(@consumer, @token, @secret)

    # Rebuild clean RequestToken params
    @request_token_params = session[:request_token_params]
    @request_token_params.each do |key,value|
      @request_token_params[key.to_sym] = value
    end
    raise

    # Add clean rebuilt params to RequestToken
    @request_token.params = session[:request_token_params]

    # Add oauth_verifier in #get_access_token
    verifier = params[:oauth_verifier]
    @access_token = @request_token.get_access_token(:oauth_verifier => verifier)
    raise
  end

  def destroy
  end

  private

  def find_provider
    @provider = params[:provider]
  end

end
