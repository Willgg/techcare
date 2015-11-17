class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    # Est-ce que le current_user est le patient ? avec un if
    # Selectionner les messages du coach et les marque comme read_at = Time.now
    # if current_user == @user
    # Aller chercher les message où read_at est nil
    # Aller chercher les messages dont le destinaire est @user (patient)
      @messages = Message.where(read_at: nil)
      @messages = @messages.where(recipient: current_user)
      @messages.each do |message|
        message.read_at = Time.now
        message.save
      end
    # end


    #Est-ce que le current_user est le coach ? avec else
    # Selectionner et marquer les message du patient comme lu read_at = Time.now

    @goals = Goal.where(user: @user)
    @message = Message.new
    @sent_messages = User.find(params[:user_id]).sent_messages
    @received_messages = User.find(params[:user_id]).received_messages
    @messages = []
    @sent_messages.each { |message| @messages << message}
    @received_messages.each { |message| @messages << message}
    @messages.sort!

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
