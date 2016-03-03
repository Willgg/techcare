class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create, :destroy]
  after_action :verify_authorized, except: [:index, :create, :destroy], unless: :devise_or_admin_controller?

  def index
    redirect_to advisers_path if @user.adviser.blank?

    # Set food_picture and index for food_picture card
    @food_picture = FoodPicture.new
    @food_pictures = @user.food_pictures.order(created_at: :desc).last(5)

    # Set messages as read
    @messages = policy_scope(Message.where(read_at: nil, recipient: current_user))
    @messages.each do |message|
      message.read_at = Time.now
      message.save
    end

    # Set new message for chat form
    @message = Message.new

    # Set the messages to display in chat windows
    @sent_messages = User.find(params[:user_id]).sent_messages
    @received_messages = User.find(params[:user_id]).received_messages
    @messages = []
    @sent_messages.each { |message| @messages << message}
    @received_messages.each { |message| @messages << message}
    @messages.sort!{ |x,y| y <=> x }

    # Set goals to display
    @goals = policy_scope(Goal.where(user_id: @user))
    # Set goal for modal form
    @goal  = Goal.new
    @measure_types_of_user = @user.measure_types.uniq
    # Custom Goal policy with 3 arguments
    raise Pundit::NotAuthorizedError unless GoalPolicy.new(current_user, @user, @goal).index?
  end

  # ATTENTION please confirm this method is not used anymore !!!
  def new
    @user = User.find(params[:user_id])
    @measure_types_of_user = @user.measure_types.uniq
    raise
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params_goals)
    @goal.user_id = params[:user_id]
    @goal.adviser = current_user.coach
    @goal.start_date = Time.now
    raise Pundit::NotAuthorizedError unless GoalPolicy.new(current_user, @user, @goal).create?
    if @goal.save
      flash[:notice] = I18n.t('controllers.goals.created', default: "Goal has been successfully created.")
      redirect_to user_goals_path(@user)
    else
      render :new
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    raise Pundit::NotAuthorizedError unless GoalPolicy.new(current_user, @user, @goal).destroy?

    if @goal.delete
      flash[:notice] = I18n.t('controllers.goals.destroy_success', default: "Goal has been successfully deleted.")
      redirect_to user_goals_path()
    else
      flash[:alert] = I18n.t('controllers.goals.destroy_fail', default: "Goal has been not been deleted.")
      redirect_to user_goals_path()
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def params_goals
    params.require(:goal).permit(:measure_type_id, :user_id, :goal_value, :end_date, :title, :cumulative)
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
