desc "Iterate on goals and add an end_value for each goal"
task :goals_closing_job => :environment do
  puts "Start goals closing..."
  GoalsClosingJob.perform_later
  puts "Goals closing done."
end
