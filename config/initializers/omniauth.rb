Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
