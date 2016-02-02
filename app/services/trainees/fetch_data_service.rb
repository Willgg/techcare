module Trainees

  attr_reader :user_id, :provider, :user, :token

  class FetchDataService

    def initialize(user, options = {})
      @user            = user
      @options         = options
      @consumer_key    = ENV['FITBIT_CONSUMER_KEY']
      @consumer_secret = ENV['FITBIT_CONSUMER_SECRET']
      @locale          = options[:locale] || "" if options.has_key?(:locale)
      if options.has_key?(:authorization)
        @provider      = options[:authorization].source.to_sym
        @token         = options[:authorization].token
        @secret        = options[:authorization].secret
        @user_id       = options[:authorization].uid
      end
    end

    def update!
      @user.authorizations.each do |auth|
        @options[:authorization] = auth
        @provider = auth.source.to_sym
        fetch!
      end
    end

    def fetch!
      case @provider

      when :fitbit
        fetch_fitbit_data
      when :withings
        fetch_withings_data
      else
        raise Trainees::ArgumentError, "Missing required options: provider (or not recognized)"
      end
    end

    private

    def fetch_fitbit_data
      Trainees::Measures::FetchFitbitService.new(@user, @options).call
    end

    def fetch_withings_data
      Trainees::Measures::FetchWithingsService.new(@user, @options).call
    end
  end

end
