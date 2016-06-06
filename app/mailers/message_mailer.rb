class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.new_message.subject
  #
  def new_message(message)
    @recipient = User.find(message.recipient_id)
    @sender = User.find(message.sender_id)
    @message = message
    @locale = (I18n.locale == I18n.default_locale ? nil : I18n.locale)

    mail to: @recipient.email, subject: t('.subject', user: @sender.first_name)
  end
end
