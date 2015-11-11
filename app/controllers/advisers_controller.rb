class AdvisersController < ApplicationController
  def index
    @advisers = Adviser.all
  end
end
