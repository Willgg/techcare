module Trainees
  require 'withings-api'
  require 'withings'
  include Withings
  include Withings::Api

  class FetchMeasuresService
    def initialize(user)
      Withings.consumer_key    = ENV['WITHINGS_OAUTH_CONSUMER_KEY']
      Withings.consumer_secret = ENV['WITHINGS_OAUTH_CONSUMER_SECRET']
      oauth_token = user.api_consumer_key
      oauth_token_secret = user.api_consumer_secret
      user_id = user.api_user_id

      response       = Withings::Connection.get_request('/user', oauth_token, oauth_token_secret, :action => :getbyuserid, :userid => user_id)
      user_data      = response['users'].detect { |item| item['id'] == user_id.to_i }
      @withings_user = Withings::User.new(user_data.merge({:oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret}))
      @user          = user
    end

    def fetch!

      if @user.measures.exists?
        last_measure_withings = @user.measures.where(source: "withings").order(created_at: :asc).last
        data = @withings_user.measurement_groups(start_at: last_measure_withings.created_at, end_at: Time.current)
      else
        data = @withings_user.measurement_groups()
      end
      #user.measurement_groups(measurement_type: 1)
      #user.measurement_groups(device: Withings::SCALE)

      data.each do |measure|
        if measure.weight
          m = Measure.new
          m.measure_type_id  = 1
          m.value            = measure.weight
          m.date             = measure.taken_at
          m.user             = @user
          m.source           = "withings"
          m.save
        end

        if measure.systolic_blood_pressure
          m = Measure.new
          m.measure_type_id  = 2
          m.value            = measure.systolic_blood_pressure
          m.date             = measure.taken_at
          m.user             = @user
          m.source           = "withings"
          m.save
        end

        if measure.ratio
          m = Measure.new
          m.measure_type_id  = 3
          m.value            = measure.ratio
          m.date             = measure.taken_at
          m.user             = @user
          m.source           = "withings"
          m.save
        end
      end
    end
  end
end
