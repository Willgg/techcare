class ProvidersController < ApplicationController
  require 'withings-api'
  require 'withings'
  include Withings
  include Withings::Api


  def index
  end

  def create
    callback_url = "http://localhost:3000" + providers_callback_path
    consumer_token = ConsumerToken.new(
                      ENV['WITHINGS_OAUTH_CONSUMER_KEY'],
                      ENV['WITHINGS_OAUTH_CONSUMER_SECRET']
                    )
    request_token_response = Withings::Api.create_request_token(consumer_token, callback_url)
    request_token = request_token_response.request_token
    current_user.api_consumer_key = request_token.key
    current_user.api_consumer_secret = request_token.secret
    current_user.save
    # redirection du user vers la page d'autorisation Withings
    redirect_to request_token_response.authorization_url

  end

  def save_token
    # Reconstruire la signature
    id = params[:userid]
    oauth_consumer_key = ENV['WITHINGS_OAUTH_CONSUMER_KEY']
    oauth_nonce = Random.rand(100000).to_s
    oauth_signature_method = 'HMAC-SHA1'
    oauth_token = current_user.api_consumer_key
    oauth_timestamp = Time.now.to_i.to_s
    oauth_version = '1.0'

    url =  'https://oauth.withings.com/account/access_token?'

    parameters = 'oauth_consumer_key=' +
                  oauth_consumer_key +
                  '&oauth_nonce=' +
                  oauth_nonce +
                  '&oauth_signature_method=' +
                  oauth_signature_method +
                  '&oauth_timestamp=' +
                  oauth_timestamp +
                  '&oauth_token=' +
                  oauth_token +
                  '&oauth_version=' +
                  oauth_version +
                  '&userid='+
                  id

    base_string = 'GET&' + CGI.escape(url) + CGI.escape(parameters)

    ## Cryptographic hash function used to generate oauth_signature
    # by passing the secret key and base string. Note that & has
    # been appended to the secret key. Don't forget this!
    #
    # This line of code is from a SO topic
    # (http://stackoverflow.com/questions/4084979/ruby-way-to-generate-a-hmac-sha1-signature-for-oauth)
    # with minor modifications.
    secret_key = ENV['WITHINGS_OAUTH_CONSUMER_SECRET']
    oauth_signature = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',secret_key, base_string)}").chomp)

    # Construire la requete http

    url = "https://oauth.withings.com/account/access_token?oauth_consumer_key=" + oauth_consumer_key + "&oauth_nonce=" + oauth_nonce + "&oauth_signature=" + oauth_signature + "&oauth_signature_method=" + oauth_signature_method + "&oauth_timestamp=" + oauth_timestamp + "&oauth_token=" + oauth_token + "&oauth_version=" + oauth_version + "&userid=" + id
    url.slice!("%3D")
    response = open(url).read

    raise
    current_user.user_id
    access_token_response = Withings::Api.create_access_token(Withings::Api.create_request_token(consumer_token, callback_url).request_token, consumer_token, "user_id_not_currently_required_by_withings")

    # access_token          = access_token_response.access_token

    # user_id            = access_token_response.user_id
    # oauth_token        = access_token.key
    # oauth_token_secret = access_token.secret

    @user = current_user
    @user.api_user_id = params[:userid]
    @user.api_consumer_key = params[:oauth_token]
    @user.api_consumer_secret = params[:oauth_verifier]
    @user.save
    # api_consumer_key
    # api_consumer_secret
    # api_user_id
    redirect_to user_goals_path(current_user)
  end
end
