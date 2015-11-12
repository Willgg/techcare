class GoalsController < ApplicationController
  before_action :find_user, only: [:index, :create]

  def index
    @goals = Goal.where(user: @user)
  end

  def new
    #----- put un the model
    # @measure_types = []
    # @measures = User.find(params[:user_id]).measures
    # @measures.each do |measure|
    # @measure_types << measure.measure_type
    # end
    # @measure_types.uniq!
    #-------
    @user = User.find(params[:user_id])
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params_goals)
    @goal.user_id = params[:user_id] # Je rentre le user_id séparement car il ne passe pas dans les params_goals ???
    @goal.adviser = current_user.coach
    if @goal.save
      redirect_to user_goals_path(@user)
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
    params.require(:goal).permit(:measure_type_id, :user_id, :end_value, :end_date, :title, :cumulative)
  end
end
