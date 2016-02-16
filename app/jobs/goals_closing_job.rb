class GoalsClosingJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    # Get all the goals that are outdated and with no end_value
    goals = Goal.where("end_date < ?", Time.current)

    unless goals.empty?
      goals.each do |goal|
        # Save the end_value
        if goal.end_value.nil?
          goal.end_value = goal.cumulative ? goal.sum_of_measures : goal.last_measure_for_user
          puts "goal(#{goal.id}) with end_value = #{goal.end_value} saved" if goal.save
        end

        # Create a new goal if not already succeed
        unless goal.is_succeed?
          trainee = goal.user
          measure_type_id = goal.measure_type_id
          Trainees::CreateGoalsService.new(trainee).only_for(measure_type_id)
        end
      end
    end
    puts "Performing GoalsClosingJob !!!"
  end
end
