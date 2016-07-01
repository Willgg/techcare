module Trainees
  module Goals
    class CreateStepService
      def initialize(trainee)
        @trainee = trainee
      end

      def call
        return unless new_goal_is_required?
        if last_measure && average_measure_value <= goal_value
          g = Goal.new
          g.measure_type = measure_type
          g.user         = @trainee
          g.adviser_id   = @trainee.adviser.id
          g.cumulative   = true
          g.end_date     = Time.current + 1.week
          g.start_date   = Time.current
          g.goal_value   = goal_value * ((g.end_date - g.start_date) / 1.day).round
          g.title        = I18n.t('controllers.goals.step_title', goal_value: g.goal_value)
          g.save
        end
      end

      private

      def goal_value
        average_measure_value > 0 && average_measure_value <= 9000 ? (average_measure_value + 1000) : 10000
      end

      def new_goal_is_required?
        @trainee.goals.where(measure_type: measure_type).none? { |g| g.is_running? && !g.is_achieved? }
      end

      def already_has_running_goal?
        @trainee.goals.where(measure_type: measure_type).any? { |goal| goal.is_running? }
      end

      def last_measure
        @last_measure ||= @trainee.measures.where(measure_type: measure_type).order(date: :desc).first
      end

      def average_measure_value
        return @average_measure_value if @average_measure_value
        count = sum = 0
        measures = @trainee.measures.activities(:desc)
        measures.each { |m| count += 1; sum += m.value.to_f }
        @average_measure_value = (sum / count)
      end

      def measure_type
        @measure_type ||= MeasureType.find(4) # FIXME: we can't have static IDs !!!
      end
    end
  end
end
