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
          flash[:notice] = 'Votre image a bien été ajoutée'
        else
          flash[:alert] = 'Il y a eu un problème avec votre image'
          @measure.delete
        end
      else
        flash[:alert] = 'Il y a eu un problème avec l\'enregistrement '
      end
    else
      flash[:alert] = 'Veuillez sélectionner une image à télécharger'
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
