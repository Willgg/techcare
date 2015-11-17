class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    @goals = Goal.where(user: @user)
    @message = Message.new
    @sent_messages = User.find(params[:user_id]).sent_messages
    @received_messages = User.find(params[:user_id]).received_messages
    @messages = []
    @sent_messages.each { |message| @messages << message}
    @received_messages.each { |message| @messages << message}
    @messages.sort!

    # modal goal new
    @goal = Goal.new
    @measure_types_of_user = @user.measure_types.uniq

  end

  def new
    @user = User.find(params[:user_id])
    @measure_types_of_user = @user.measure_types.uniq
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params_goals)
    @goal.user_id = params[:user_id] # Je rentre le user_id séparement car il ne passe pas dans les params_goals ???
    @goal.adviser = current_user.coach
    @goal.start_date = Time.now
    if @goal.save
      redirect_to user_goals_path(@user)
    else
      render :new
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.delete
    redirect_to user_goals_path()
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
  def params_goals
    params.require(:goal).permit(:measure_type_id, :user_id, :end_value, :end_date, :title, :cumulative)
  end
end
