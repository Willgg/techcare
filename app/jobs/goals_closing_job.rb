class GoalsClosingJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    puts "*** Save the end_value of each outdated goal ***"

    goals_over = Goal.where("end_value IS NULL AND end_date < ?", Time.current)

    unless goals_over.empty?
      goals_over.each do |goal|
        if goal.end_value.nil?
          goal.end_value = goal.cumulative ? goal.sum_of_measures : goal.last_measure_for_user
          puts "For Goal(#{goal.id}), end_value(#{goal.end_value}) has been saved" if goal.save
        end
      end
    end

    puts "*** Check if new goals have to be created ***"

    User.all.each do |user|
      puts "Analyzing user : #{user.id}"
      MeasureType.all.each do |mt|
        goals = user.goals.where(measure_type_id: mt.id)
        if goals.none? { |g| g.is_running? || g.is_succeed? } # && user.measures.any? { |m| m.measure_type_id == mt.id }
          puts "New goal on #{mt.name} needed"
          Trainees::CreateGoalsService.new(user).only_for(mt.id)
        end
      end
    end

  end
end
