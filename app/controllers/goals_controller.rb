class GoalsController < ApplicationController

  def index
    @goals = Goal.all
  end

  def new
  end

  def create
  end

  def destroy
  end
end
