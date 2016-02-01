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

        client = Fitgem::Client.new(consumer_key: @consumer_key, consumer_secret: @consumer_secret, token: @token, secret: @secret, user_id: @user_id)
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

        @data = { activities: activities, body_weight: body_weight, body_fat: body_fat }
      end

      def save_fitbit_data!
        @data.each do |type,measures|
          measures.values.flatten.each do |i|
            m = Measure.new
            m.user   = @user
            m.source = @provider.to_s
            # Measure of Steps per day
            if i.has_key?("value")
              m.measure_type_id  = 4
              m.value            = i["value"]
              m.date             = Date.parse(i["dateTime"])
              m.save
            # Measure of Weight
            elsif i.has_key?("weight")
              m.measure_type_id  = 1
              m.value            = i["weight"]
              m.date             = Date.parse(i["dateTime"] ||= i["date"])
              m.save
            # Measure of Fat
            elsif i.has_key?("fat")
              m.measure_type_id  = 3
              m.value            = i["fat"]
              m.date             = Date.parse(i["dateTime"] ||= i["date"])
              m.save
            end
          end
        end
      end

    end
  end
end
