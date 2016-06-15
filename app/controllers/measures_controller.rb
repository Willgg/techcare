class MeasuresController < ApplicationController
  before_action :find_user
  before_action :find_measure, only: [:update]
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
    authorize @measure
    if @measure.update(params_measure)
      flash[:notice] = @measure.class.name + " has been successfully updated."
    else
      flash[:alert] = @measure.errors.messages.values.join(', ')
    end
    respond_to do |format|
      format.html { redirect_to(user_goals_path(@user)) }
      format.js   { render 'food_pictures/update.js.erb' }
    end
  end

  def destroy
  end

  private

  def find_measure
    @measure = Measure.find(params[:id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def params_measure
    params.require(:measure).permit(:measure_type_id, :value, :date)
  end

end
