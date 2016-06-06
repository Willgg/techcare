class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject

  def welcome(user)
    @user = user
    @locale = (I18n.locale == I18n.default_locale ? nil : I18n.locale)
    mail(to: @user.email, subject: I18n.t('mailers.user.title', name: @user.first_name))
  end

  def new_coach(user, coach)
    @user = user
    @coach = coach
    @locale = (I18n.locale == I18n.default_locale ? nil : I18n.locale)
    mail to: @coach.email, subject: t('.new_user_subject', user: @user.first_name)
  end
end
