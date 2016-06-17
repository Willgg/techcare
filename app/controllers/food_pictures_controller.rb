class FoodPicturesController < ApplicationController
  before_action :find_user, only: [:show, :new, :create]
  respond_to :js, only: [:show, :create]

  def show
    @food_picture = FoodPicture.find(params[:id])
    authorize @food_picture
  end

  def create
    @measure = Measure.new(user: @user, value: 1, measure_type_id: 5, date: Time.current, source: "techcare")
    authorize @measure

    if params.has_key? :food_picture
      if @measure.save
        @food_picture = FoodPicture.new(food_picture_params)
        @food_picture.measure = @measure
        authorize @food_picture
        if @food_picture.save
          # flash[:notice] = '@food_picture saved'
        else
          flash[:alert] = 'Problem with your picture'
          @measure.delete
        end
      else
        flash[:alert] = 'Problem with the new measure'
      end
    else
      flash[:alert] = 'Problem with the picture form'
    end

    respond_to do |format|
      format.html { redirect_to(user_goals_path(@user)) }
      format.js
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def food_picture_params
    params.require(:food_picture).permit(:picture)
  end
end
