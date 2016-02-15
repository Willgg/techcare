class GoalsClosingJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    # Get all the goals that are outdated and with no end_value
    goals = Goal.where("end_value = NULL AND end_date < ?", Time.current)

    # Save the end_value of each outdated goals if any
    unless goals.empty?
      goals.each do |goal|
        goal.end_value = goal.cumulative ? goal.sum_of_measures : goal.last_measure_for_user
        puts "goal(#{goal.id}) with end_value = #{goal.end_value} saved" if goal.save
      end
    end
  end
end
