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
            last_provider_measure = @user.measures.where(source: @provider.to_s, measure_type_id: mt.id).order(created_at: :asc).last
            base_date = last_provider_measure.date + 1.day
          end
          #FIXME : Time.now instead of Time.current
          if last_provider_measure && base_date + 1.month > Time.current

            date_option[:base_date] = base_date
            date_option[:end_date]  = Time.current

          else

            date_option[:end_date]  = Time.current
            date_option[:base_date] = date_option[:end_date] - 1.month

          end

          if mt.id == 1
            body_weight = client.body_weight(date_option)
            @data.merge!(body_weight)
          elsif mt.id == 3
            body_fat    = client.body_fat(date_option)
            @data.merge!(body_fat)
          elsif mt.id == 4
            activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
            @data.merge!(activities)
          else
            raise Trainees::ArgumentError, "The #{@provider.to_s} API do not provide data with this MeasureType"
          end

        end

        # if @user.measures.find_by(source: @provider.to_s)
        #   last_provider_measure = @user.measures.where(source: @provider.to_s).order(created_at: :asc).last
        # end

        # # Range of time must not include last_measure day
        # base_date   = last_provider_measure.date + 1.day
        # date_option = {}

        # # If range is smaller than 1 month then we set base_date and end_date
        # if last_provider_measure && base_date + 1.month > Time.current

        #   date_option[:base_date] = base_date
        #   date_option[:end_date]  = Time.current

        # # Else we set base_date (running as end_date by fitbit) and max period
        # else

        #   date_option[:base_date] = Time.current
        #   date_option[:end_date]  = date_option[:base_date] + 1.month

        # end

        # activities  = client.activity_on_date_range("steps", date_option[:base_date], date_option[:end_date])
        # body_weight = client.body_weight(date_option)
        # body_fat    = client.body_fat(date_option)

        # @data = activities.merge!(body_weight).merge!(body_fat)
        # raise
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
        #IMPROVE : 1 locale can match with 2 unit systems. Should be part of user's config
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
