ActionMailer::Base.smtp_settings = {
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_APIKEY'],
  :address =>        'smtp.mandrillapp.com',
  :port =>           587,
  :domain =>         'techcare.io',
  :authentication => 'plain',
  :enable_starttls_auto => true
}
