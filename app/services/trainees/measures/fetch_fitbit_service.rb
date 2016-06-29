module Trainees
  module Measures

    attr_reader :token

    class FetchFitbitService < FetchDataService

      def call
        fetch_fitbit_data
        save_fitbit_data!
      end

      def fetch_fitbit_data

        client = Fitgem::Client.new(consumer_key: @consumer_key,
                                    consumer_secret: @consumer_secret,
                                    token: @token,
                                    secret: @secret,
                                    user_id: @user_id,
                                    unit_system: set_unit_system)
        @data = {}

        MeasureType.find([1,3,4]).each do |mt|

          date_option = {}

          if @user.measures.exists?(source: @provider.to_s, measure_type_id: mt.id)
            last_provider_measure = @user.measures.where(source: @provider.to_s, measure_type_id: mt.id).order(date: :asc).last
            date_option[:base_date] = last_provider_measure.date + 1.day
          else
            date_option[:base_date] = 15.days.ago
          end
          date_option[:end_date]  = 1.days.ago

          if mt.id == 1
            body_weight = client.body_weight(date_option)
            @data.merge!(body_weight)
          elsif mt.id == 3
            body_fat    = client.body_fat(date_option)
            @data.merge!(body_fat)
          elsif mt.id == 4
            activities  = client.activity_on_date_range("steps", date_option[:base_date].to_date, date_option[:end_date].to_date)
            @data.merge!(activities)
          else
            raise Trainees::ArgumentError, "The #{@provider.to_s} API do not provide data with this MeasureType"
          end
        end
      end

      def save_fitbit_data!
        @data.each do |type,measures|
          measures.each do |h|
            unless h["value"] == 0
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
      end

      private

      def set_unit_system
        #IMPROVE : 1 locale can match with 2 unit systems. Should be part of user's config
        return Fitgem::ApiUnitSystem.METRIC unless @locale
        case @locale.upcase

        when "US"
          Fitgem::ApiUnitSystem.US
        else
          Fitgem::ApiUnitSystem.METRIC
        end
      end

    end
  end
end
