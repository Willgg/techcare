class UsersController < ApplicationController
  def index
    @users = User.where(adviser_id: current_user.coach.id)
    @unread_messages = Message.where(read_at: nil)
  end

end
