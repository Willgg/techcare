class GoalsClosingJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    puts "*** Performing GoalsClosingJob#perform ***"
    # Get all the goals that are outdated and with no end_value
    goals = Goal.where("end_date < ?", Time.current)

    unless goals.empty?
      goals.each do |goal|
        puts "*** Processing Goal [id => #{goal.id}, type => #{goal.measure_type_id}]***"
        # Save the end_value
        if goal.end_value.nil?
          goal.end_value = goal.cumulative ? goal.sum_of_measures : goal.last_measure_for_user
          puts "saved end_value = #{goal.end_value}" if goal.save
        end

        # Create a new goal if not already succeed
        unless goal.is_succeed?
          puts "Goal is failed => CreateGoalService called"
          trainee = goal.user
          measure_type_id = goal.measure_type_id
          Trainees::CreateGoalsService.new(trainee).only_for(measure_type_id)
        end
      end
    end
    puts "*** GoalsClosingJob Performed ***"
  end
end
