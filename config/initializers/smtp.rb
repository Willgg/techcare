ActionMailer::Base.smtp_settings = {
  :user_name =>      ENV['POSTMARK_API_TOKEN'],
  :password =>       ENV['POSTMARK_API_TOKEN'],
  :address =>        'smtp.postmarkapp.com',
  :port =>           '25',
  :domain =>         'heroku.com',
  :authentication => :cram_dm5,
  :enable_starttls_auto => true
}
