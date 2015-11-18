class ProvidersController < ApplicationController
  require 'withings-api'
  require 'withings'

  include Withings
  include Withings::Api

  def index
  end

  def create
    callback_url   = "http://localhost:3000" + providers_callback_path
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

    # Get access token
    access_token_response = Withings::Api.create_access_token(request_token, consumer_token, "user_id_not_currently_required_by_withings")
    access_token          = access_token_response.access_token
    user_id               = access_token_response.user_id
    oauth_token           = access_token.key
    oauth_token_secret    = access_token.secret

    # Persisting access token
    current_user.api_consumer_key = oauth_token
    current_user.api_consumer_secret = oauth_token_secret
    current_user.api_user_id = params[:userid]
    current_user.save

    # User data fetching
    Withings.consumer_key    = consumer_key
    Withings.consumer_secret = consumer_secret

    response  = Withings::Connection.get_request('/user', oauth_token, oauth_token_secret, :action => :getbyuserid, :userid => user_id)
    user_data = response['users'].detect { |item| item['id'] == user_id.to_i }
    user      = Withings::User.new(user_data.merge({:oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret}))


    # Get data from scale device
    data = user.measurement_groups
    #user.measurement_groups(measurement_type: 1)
    #user.measurement_groups(device: Withings::SCALE)

    # Measures Creation
    data.each do |measure|
      if measure.weight
        m = Measure.new
        m.measure_type_id  = 1
        m.value            = measure.weight
        m.date             = measure.taken_at
        m.user             = current_user
        m.source           = "withings"
        m.save
      end

      if measure.systolic_blood_pressure
        m = Measure.new
        m.measure_type_id  = 2
        m.value            = measure.systolic_blood_pressure
        m.date             = measure.taken_at
        m.user             = current_user
        m.source           = "withings"
        m.save
      end

      if measure.ratio
        m = Measure.new
        m.measure_type_id  = 3
        m.value            = measure.ratio
        m.date             = measure.taken_at
        m.user             = current_user
        m.source           = "withings"
        m.save
      end
    end

    # Default Goals Creation
    if ((Measure.find_by measure_type_id: 1) != nil) && (Measure.where(user_id: current_user.id, measure_type_id: 1 ).order(date: :desc).first.value > ( 25 * ( ( current_user.height.to_f / 100 ) ** 2 ) ).round(1)) && ((Goal.find_by measure_type_id: 1) != nil)
      g = Goal.new
      g.measure_type_id = 1
      g.end_value       = ( 25 * ( ( current_user.height.to_f / 100 ) ** 2 ) ).round(1) # height in meter
      g.user            = current_user
      g.adviser_id      = current_user.adviser.id
      g.title           = "Keep your weight under #{g.end_value} kg"
      g.cumulative      = false
      last_weight       = Measure.where(user_id: current_user.id, measure_type_id: g.measure_type_id ).order(date: :desc)
      weight_to_lose    = last_weight.first.value - g.end_value
      g.end_date        = Time.now + ( ( weight_to_lose / ( 0.5 / 7 ) ).round(2).to_f.days ) # Total loss / loss per day = Goal length
      g.start_date      = Time.now
      g.save
    end
    if ((Measure.find_by measure_type_id: 2) != nil ) && (Measure.where(user_id: current_user.id, measure_type_id: 2 ).order(date: :desc).first.value > 140 ) && ((Goal.find_by measure_type_id: 2) != nil )
      g = Goal.new
      g.measure_type_id = 2
      g.end_value       = 140
      g.user            = current_user
      g.adviser_id      = current_user.adviser.id
      g.title           = "Low your blood pressure to #{g.end_value.to_i} mmHg"
      g.cumulative      = false
      g.end_date        = Time.now + 30.days
      g.start_date      = Time.now
      g.save
    end
    if ( (Measure.find_by measure_type_id: 3) != nil ) && ( Measure.where(user_id: current_user.id, measure_type_id: 3 ).order(date: :desc).first.value > 25 ) && ( (Goal.find_by measure_type_id: 3) != nil )
      g = Goal.new
      g.measure_type_id = 3
      g.end_value       = 25
      g.user            = current_user
      g.adviser_id      = current_user.adviser.id
      g.title           = "Reach 25% fat mass ratio"
      g.cumulative      = false
      g.end_date        = Time.now + 30.days
      g.start_date      = Time.now
      g.save
    end

    # Redirection to dashboard
    if !current_user.is_adviser && current_user.measures.exists?
        flash[:notice] = "Your withings data has been synchronized"
        redirect_to user_goals_path(current_user)
    else
        flash[:alert] = "Unable to synchronize your data"
        redirect_to providers_path
    end

  end
end
