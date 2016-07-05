class MeasuresFetchingJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Authorization.all.each do |auth|
      case auth.source.to_sym
        when :withings
          Trainees::FetchMeasuresService.new(auth.user).fetch!
        when :fitbit
          Trainees::FetchDataService.new(auth.user, authorization: auth).fetch!
        else
          puts 'source not recognized for ' + auth.inspect
      end
    end
  end
end
