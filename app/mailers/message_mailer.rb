class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.new_message.subject
  #
  def new_message(message)
    @recipient = User.find(message.recipient_id)
    @sender    = User.find(message.sender_id)
    @message   = message
    @locale    = I18n.locale
    @url       = @recipient.is_adviser ? users_url(locale: @locale) : user_goals_url(locale: @locale, user_id: @recipient.id)
    mail to: @recipient.email, subject: t('.subject', user: @sender.first_name)

  end
end
