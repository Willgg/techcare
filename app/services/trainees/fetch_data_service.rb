module Trainees

  attr_reader :user_id, :provider, :user

  class FetchDataService

    def initialize(user, options)
      @user            = user
      @provider        = options[:provider]
      @token           = options[:token]
      @secret          = options[:secret]
      @consumer_key    = options[:consumer_key]
      @consumer_secret = options[:consumer_secret]
      @user_id         = options[:user_id]
    end

    def fetch!

      # Check if existing measures in order to set a time window
      if @user.measures.find_by(source: @provider.to_s)
        last_provider_measure = @user.measures.where(source: @provider.to_s).order(created_at: :asc).last
      end

      # Fetch the data from Provider
      case @provider

      when :fitbit
        client = Fitgem::Client.new(consumer_key: @consumer_key, consumer_secret: @consumer_secret, token: @token, secret: @secret, user_id: @user_id)
        date_option = { end_date: Time.current.strftime("%Y-%m-%d") }

        if last_provider_measure
          date_option[:base_date] = last_provider_measure.created_at
          raise
          activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
        else
          date_option[:base_date] = Time.current.months_ago(1).strftime("%Y-%m-%d")
          activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
        end

        body_weight = client.body_weight(date_option)
        body_fat    = client.body_fat(date_option)

      when :withings
        activities  = nil
        body_weight = nil
        body_fat    = nil
      else
        raise Trainees::ArgumentError, "Missing required options: provider (or not recognized)"
      end

      # Save data for each type of measure
      data = { activities: activities, body_weight: body_weight, body_fat: body_fat }

      data.each do |type,measures|
        measures.values.flatten.each do |i|
          m = Measure.new
          m.user   = @user
          m.source = @provider.to_s
          if i.has_key?("value")
            m.measure_type_id  = 4
            m.value            = i["value"]
            m.date             = Date.parse(i["dateTime"])
          elsif i.has_key?("weight")
            raise
            m.measure_type_id  = 1
            m.value            = i["value"]
            m.date             = Date.parse(i["dateTime"])
          end
          m.save
        end

      end

      #{"activities-log-steps":[{"dateTime":"2011-04-27","value":5490}]}
      #{"weight":[{"bmi":23.57,"date":"2015-03-05","logId":1330991999000,"time":"23:59:59","weight":73,"source": "API"}]}

      raise
    end
  end

end
