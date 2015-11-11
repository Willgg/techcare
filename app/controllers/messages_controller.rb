class MessagesController < ApplicationController

  def create
    @message = Message.new(params_messages)
  end

  def destroy
  end


  private

  def params_messages
    params.require(:message).permit(:content, :sender_id, :recipient_id)
  end

end
