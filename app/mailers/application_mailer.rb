class ApplicationMailer < ActionMailer::Base

  default from: I18n.t('mailers.application.sender')
  layout 'mailer'

end
