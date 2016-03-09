class GoalsClosingJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    puts "*** Save the end_value for outdated goals ***"

    goals_over = Goal.where("end_value IS NULL AND end_date < ?", Time.current)

    unless goals_over.empty?
      goals_over.each do |goal|
        goal.end_value = goal.cumulative ? goal.sum_of_measures : goal.last_measure_for_user
        puts "For Goal(#{goal.id}), end_value(#{goal.end_value}) has been saved" if goal.save
      end
    end

    puts "*** Check if new goals have to be created ***"

    User.all.each do |user|
      puts ">> Analyzing user:(#{user.id})"
      all_measure_type_before(5).all.each do |mt|
        puts "Analyzing goals for #{mt.name}"
        goals = user.goals.where(measure_type_id: mt.id)
        # Create a goal if goal is failed or does not exist
        if goals.none? {|g|g.is_running?||g.is_succeed?} # && user.measures.any? { |m| m.measure_type_id == mt.id }
          puts "No Goals running nor succeed: request for new goal"
          Trainees::CreateGoalsService.new(user).only_for(mt.id)
        end
      end
      puts ""
    end

  end

  private

  def all_measure_type_before(id)
    MeasureType.where('id < ?', id)
  end

end
