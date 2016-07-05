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
      @data          = {}
    end

    def fetch!
      MeasureType.where('id != 5').each { |mt| @data.merge!( fetch_data(mt) ) }
      save_data!(@data)
    end

    private

    def fetch_data(measure_type)
      options = {}
      if @user.measures.exists?(source: "withings", measure_type_id: measure_type.id)
        base_date = @user.measures.where(source: "withings", measure_type_id: measure_type.id).order(date: :asc).last.date
        options   = { start_at: base_date, end_at: Time.current }
      else
        base_date = 15.days.ago
      end
      options_activities = { startdateymd: base_date.strftime("%F"),
                             enddateymd:   Time.current.strftime("%F") }
      case measure_type.id
      when 1
        options[:measurement_type] = Withings::MeasurementGroup::TYPE_WEIGHT
        { weight: @withings_user.measurement_groups(options) }
      when 2
        options[:measurement_type] = Withings::MeasurementGroup::TYPE_SYSTOLIC_BLOOD_PRESSURE
        { systolic_blood_pressure: @withings_user.measurement_groups(options) }
      when 3
        options[:measurement_type] = Withings::MeasurementGroup::TYPE_FAT_RATIO #FIXME API broken for fat
        { fat: @withings_user.measurement_groups(options) }
      when 4
        activities = @withings_user.get_activities(options_activities)
        { activities: activities["activities"] }
      end
    end

    def save_data!(data)
      # Gem withings : #weight, #fat, #size, #ratio, #fat_free,
      #diastolic_blood_pressure/#systolic_blood_pressure, #heart_pulse,
      #group_id, #taken_at
      @data.each do |type,dataset|
        dataset.each do |datapoint|
          m = Measure.new(user: @user, source: "withings")
          if type == :activities
            m.measure_type_id    = 4
            m.value              = datapoint["steps"]
            m.date               = datapoint["date"].to_date
          else
            m.date = datapoint.taken_at
            if datapoint.weight
              m.measure_type_id  = 1
              m.value            = datapoint.weight
            elsif datapoint.systolic_blood_pressure
              m.measure_type_id  = 2
              m.value            = datapoint.systolic_blood_pressure
            elsif datapoint.ratio
              m.measure_type_id  = 3
              m.value            = datapoint.ratio
            end
          end
          save_measure!(m)
        end
      end
    end

    def save_measure!(measure)
      options = {user: measure.user.id,
                 measure_type_id: measure.measure_type_id,
                 date: measure.date,
                 source: measure.source}
      if Measure.exists?(options)
        record = Measure.where(options).first
        record.update!(value: measure.value) if measure.value != record.value
      else
        measure.save
      end
    end

  end
end
