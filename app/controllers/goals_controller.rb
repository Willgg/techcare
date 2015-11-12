class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    @goals = Goal.where(user: @user)
    # trouver les mesures du user
    @measure = Measure.where(user_id: @user)
    # trouver les mesures qui ont le meme measure_type

  end

  def new
  end

  def create
    @goal = Goal.new(params_goals)
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
