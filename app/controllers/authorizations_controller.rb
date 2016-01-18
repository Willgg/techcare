class AuthorizationsController < ApplicationController
  skip_after_action :verify_authorized

  def create
    @provider = params[:provider]
    @callback_url = ENV['HOST'] + "/auth/#{@provider}/callback"
    @consumer = OAuth::Consumer.new(ENV['FITBIT_CONSUMER_KEY'],ENV['FITBIT_CONSUMER_SECRET'], :site => "https://api.fitbit.com")
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = @request_token

    # Create an new Authorization
    @authorization = Authorization.new(
                      key: @request_token.token,
                      secret: @request_token.secret,
                      user: current_user,
                      source: @provider
                    )
    if @authorization.save
      redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)
    else
      flash[:alert] = I18n.t('controllers.providers.error', default: "Unable to synchronize your data.")
      redirect_to providers_path
    end
  end

  def save_token
    @provider = params[:provider]

    raise
  end

  def destroy
  end

  private

end
