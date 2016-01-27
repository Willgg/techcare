module Trainees
  module Goals
    class CreateStepService
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
          g.title           = "Keep your weight under #{goal_value} kg" #FIXME I18n for title
          g.cumulative      = true
          g.end_date        = Time.current
          g.start_date      = Time.current
          g.save
        end
      end

      private

      def goal_value
        (10000 * 7)
      end

      def already_has_goal?
        @trainee.goals.where(measure_type: measure_type).exists?
      end

      def last_measure
        @last_measure ||= @trainee.measures.where(measure_type: measure_type).order(date: :desc).first
      end

      def measure_type
        @measure_type ||= MeasureType.find(4) # FIXME: we can't have static IDs !!!
      end
    end
  end
end
