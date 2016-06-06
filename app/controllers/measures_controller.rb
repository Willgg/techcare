class MeasuresController < ApplicationController
  before_action :find_user
  after_action :verify_authorized

  def create
    @measure = Measure.new(params_measure)
    @measure.source = "manual"
    @measure.user = @user
    authorize @measure
    if @measure.save
      flash[:notice] = t('.success')
      redirect_to user_goals_path(@user)
    else
      raise
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def params_measure
    params.require(:measure).permit(:measure_type_id, :value, :date)
  end

end
