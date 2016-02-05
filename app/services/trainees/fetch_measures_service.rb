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

      data = {}

      MeasureType.all.each do |mt|

        if @user.measures.exists?(source: "withings", measure_type_id: mt.id)
          last_measure_withings = @user.measures.where(source: "withings", measure_type_id: mt.id).order(date: :asc).last
          base_date = last_measure_withings.date + 1.day
          options = { start_at: base_date, end_at: Time.current }
        else
          base_date = Time.current - 1.month
          options = {}
        end
        options_string = { startdateymd: base_date.strftime("%F"), enddateymd: Time.current.strftime("%F") }

        if mt.id == 4
          activities = @withings_user.get_activities(options_string)
          data[:activities] = activities["activities"]
        else
          if mt.id == 1
            options[:measurement_type] = Withings::MeasurementGroup::TYPE_WEIGHT
            data[:weight] = @withings_user.measurement_groups(options)
          elsif mt.id == 2
            options[:measurement_type] = Withings::MeasurementGroup::TYPE_SYSTOLIC_BLOOD_PRESSURE
            data[:systolic_blood_pressure] = @withings_user.measurement_groups(options)
          elsif mt.id == 3
            options[:measurement_type] = Withings::MeasurementGroup::TYPE_FAT_RATIO #FIXME API broken for fat
            data[:fat] = @withings_user.measurement_groups(options)
          end
        end

      end
      #FIXME : revoir la creation des measures
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
