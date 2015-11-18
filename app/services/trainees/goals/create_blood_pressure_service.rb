module Trainees
  module Goals
    class CreateBloodPressureService
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
          g.title           = "Low your blood pressure to #{goal_value.to_i} mmHg"
          g.cumulative      = false
          g.end_date        = Time.current + 30.days
          g.start_date      = Time.current
          g.save
        end
      end

      private

      def goal_value
        @goal_value ||= 140
      end

      def already_has_goal?
        @trainee.goals.where(measure_type: measure_type).exists?
      end

      def last_measure
        @last_measure ||= @trainee.measures.where(measure_type: measure_type).order(date: :desc).first
      end

      def measure_type
        @measure_type ||= Measure.find_by(measure_type_id: 2) # FIXME: we can't have static IDs !!!
      end
    end
  end
end
