class UsersController < ApplicationController
  def index
    @users = User.where(adviser_id: current_user.coach.id)
  end

end
