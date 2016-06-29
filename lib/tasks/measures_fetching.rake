desc "Iterate on goals and add an end_value for each goal"
task :measures_fetching_job => :environment do
  puts "*** Start to synchronize measures from providers... ***"
  MeasuresFetchingJob.perform_now
  puts "*** measures synchronization done. ***"
end
