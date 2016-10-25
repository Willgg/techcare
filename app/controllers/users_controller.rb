class UsersController < ApplicationController

  after_action :verify_authorized, except: [:index, :show], unless: :devise_or_admin_controller?
  after_action :verify_policy_scoped, except: [:index, :show], unless: :devise_or_admin_controller?
  respond_to :js, only: :show

  def index
    @users = User.where(adviser_id: current_user.coach.id)
    @unread_messages = Message.where(read_at: nil)


    @user = current_user
    @message = Message.new
    @sent_messages = Message.where(sender: current_user)
    @received_messages = Message.where(recipient: current_user)
    @messages = []
    @sent_messages.each { |message| @messages << message}
    @received_messages.each { |message| @messages << message}
    @messages.sort!


    users = User.where(adviser: current_user)
    @user_names = []
    users.each do |user|
      @user_names << user
    end

    @default_trainee = @users.first
  end

  def show
    @user = User.find(params[:id])
  end

end
