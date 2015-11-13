class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    @goals = Goal.where(user: @user)
    @message = Message.new
  end

  def new
  end

  def create
    @goal = Goal.new(params_goals)
    @goal.start_date = Time.now
    if @goal.save
      redirect_to user_goals(@user)
    else
      render :new
    end
  end

  def destroy
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
  def params_goals
    params.require(:goal).permit(:measure_type_id, :user_id, :end_value, :end_time, :title, :cumulative)
  end
end
