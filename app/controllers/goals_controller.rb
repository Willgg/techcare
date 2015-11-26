class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    # Set messages as read
    @messages = policy_scope(Message)

    @messages.each do |message|
      message.read_at = Time.now
      message.save
    end

    # Set the messages to display in chat windows
    @message = Message.new
    @sent_messages = User.find(params[:user_id]).sent_messages
    @received_messages = User.find(params[:user_id]).received_messages
    @messages = []
    @sent_messages.each { |message| @messages << message}
    @received_messages.each { |message| @messages << message}
    @messages.sort!{ |x,y| y <=> x }

    # Set goals to display
    @goals = policy_scope(Goal)
    # Set goal for modal form
    @goal  = Goal.new
    @measure_types_of_user = @user.measure_types.uniq

    if current_user == @user || current_user == @user.adviser
      authorize Goal
    else
      raise Pundit::NotAuthorizedError
    end
  end

  # ATTENTION please confirm this method is not used anymore !!!
  def new
    @user = User.find(params[:user_id])
    @measure_types_of_user = @user.measure_types.uniq
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params_goals)
    @goal.user_id = params[:user_id]
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

  def user_not_authorized
    flash[:alert] = I18n.t('controllers.application.user_not_authorized', default: "You can't access this page.")
    if current_user.is_adviser
      redirect_to(users_path)
    else
      redirect_to(user_goals_path(current_user))
    end
  end
end
