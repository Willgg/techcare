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
    # @messages.order(created_date: :asc).last.value
    # @messages.find(:all, :order => "created_at ASC")

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
