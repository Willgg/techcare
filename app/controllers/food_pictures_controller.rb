class FoodPicturesController < ApplicationController
  before_action :find_user, only: [:new, :create]
  def new
    @food_picture = FoodPicture.new
  end

  def create
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
