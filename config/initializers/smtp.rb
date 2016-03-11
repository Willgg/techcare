ActionMailer::Base.smtp_settings = {
  :user_name =>      ENV['POSTMARK_API_TOKEN'],
  :password =>       ENV['POSTMARK_API_TOKEN'],
  :address =>        'smtp.postmarkapp.com',
  :port =>           587,
  :domain =>         'techcare.io',
  :authentication => 'plain',
  :enable_starttls_auto => true
}
