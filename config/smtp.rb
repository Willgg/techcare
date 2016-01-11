ActionMailer::Base.smtp_settings = {
  :port =>           '587',
  :address =>        'smtp.mandrillapp.com',
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_APIKEY'],
  :domain =>         'techcare.io',
  :authentication => 'login'
