class MessagesController < ApplicationController
  before_action :find_user, only: [:create, :index]
  respond_to :js, only: [:create, :index, :read, :destroy]

  def create
    @message = Message.new(messages_params)
    @message.sender = current_user

    if @user == current_user
      @message.recipient = current_user.adviser.user
    else
      @message.recipient = @user
    end
    authorize @message
    @message.save
  end

  def destroy
    @message = Message.find(params[:id])
    authorize @message
    @message.destroy
  end

  def index
    messages_sent_by_coach   = policy_scope(Message.where(recipient: @user, sender: current_user))
    messages_sent_by_patient = policy_scope(Message.where(recipient: current_user, sender: @user))
    @messages                = (messages_sent_by_coach + messages_sent_by_patient).sort_by {|m| - m.created_at.to_i }
  end

  def read
    @messages = Message.where(recipient: current_user, read_at: nil)
    @messages.each do |message|
      message.read_at = Time.current
      message.save
    end
    head :ok
  end

  private

  def find_user
    if params[:recipient_id].present?
      @user = User.find(params[:recipient_id])
    else
      @user = User.find(params[:user_id])
    end
  end

  def messages_params
    params.require(:message).permit(:content, :user, :recipient_id)
  end
end
