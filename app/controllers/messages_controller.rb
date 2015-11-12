class MessagesController < ApplicationController
  before_action :find_user, only: [:create]

  def create
    @message = Message.new(messages_params)
    @message.sender = current_user
    if @user == current_user
      @message.recipient = current_user.adviser.user
    else
      @message.recipient = @user
    end
    @message.save
    redirect_to user_goals_path(@user)

  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end


  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def messages_params
    params.require(:message).permit(:content, :user)
  end

end
