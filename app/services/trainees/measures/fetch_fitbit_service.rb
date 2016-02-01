module Trainees
  module Measures
    class FetchFitbitService < FetchDataService
      def call
        fetch_fitbit_data
        save_fitbit_data!
      end

      def fetch_fitbit_data
        if @user.measures.find_by(source: @provider.to_s)
          last_provider_measure = @user.measures.where(source: @provider.to_s).order(created_at: :asc).last
        end

        client = Fitgem::Client.new(consumer_key: @consumer_key, consumer_secret: @consumer_secret, token: @token, secret: @secret, user_id: @user_id, unit_system: Fitgem::ApiUnitSystem.METRIC)
        date_option = { end_date: Time.current.strftime("%Y-%m-%d") }

        if last_provider_measure
          date_option[:base_date] = last_provider_measure.created_at
          activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
        else
          date_option[:base_date] = Time.current.months_ago(1).strftime("%Y-%m-%d")
          activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
        end

        body_weight = client.body_weight(date_option)
        body_fat    = client.body_fat(date_option)

        @data = activities.merge!(body_weight).merge!(body_fat)
      end

      def save_fitbit_data!
        @data.each do |type,measures|
          measures.each do |h|
            m = Measure.new
            m.user   = @user
            m.source = @provider.to_s
            # Measure of Steps per day
            if h.has_key?("value")
              m.measure_type_id  = 4
              m.value            = h["value"]
              m.date             = Date.parse(h["dateTime"])
              m.save
            # Measure of Weight
            elsif h.has_key?("weight")
              m.measure_type_id  = 1
              m.value            = h["weight"]
              m.date             = Date.parse(h["dateTime"] ||= h["date"])
              m.save
            # Measure of Fat
            elsif h.has_key?("fat")
              m.measure_type_id  = 3
              m.value            = h["fat"]
              m.date             = Date.parse(h["dateTime"] ||= h["date"])
              m.save
            end
          end
        end
      end

      private

      def set_unit_system
        #FIXME : unit system based on user's :locale
      end
    end
  end
end
