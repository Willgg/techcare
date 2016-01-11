Rails.application.configure do
  config.action_mailer.smtp_settings = {
    :user_name =>       'grenier.godard@gmail.com',
    :password =>        'UGdjRO3AxMf5UyrmHYFgrA',
    :address =>         'smtp.mandrillapp.com',
    :port =>            587,
    :domain =>          'techcare.io',
    :authentication =>  'plain',
    :enable_starttls_auto => true
  }
end
