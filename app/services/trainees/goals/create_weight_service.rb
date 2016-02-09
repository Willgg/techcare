module Trainees
  module Goals
    class CreateWeightService
      def initialize(trainee)
        @trainee = trainee
      end

      def call
        return if measure_type.nil? || already_has_goal?

        if last_measure && last_measure.value > goal_value
          g = Goal.new
          g.measure_type    = measure_type
          g.end_value       = goal_value
          g.user            = @trainee
          g.adviser_id      = @trainee.adviser.id
          g.title           = I18n.t('controllers.goals.weight_title', goal_value: goal_value)
          g.cumulative      = false
          weight_to_lose    = last_measure.value - goal_value
          g.end_date        = Time.current + ((weight_to_lose / (0.5 / 7)).round(2).to_f.days) # Total loss / loss per day = Goal length
          g.start_date      = Time.current
          g.save
        end
      end

      private

      def goal_value
        @goal_value ||= ( 25 * ( ( @trainee.height.to_f / 100 ) ** 2 ) ).round # height in meter
      end

      def already_has_goal?
        @trainee.goals.where(measure_type: measure_type).exists?
      end

      def last_measure
        @last_measure ||= @trainee.measures.where(measure_type: measure_type).order(date: :desc).first
      end

      def measure_type
        @measure_type ||= MeasureType.find(1) # FIXME: we can't have static IDs !!!
      end
    end
  end
end
