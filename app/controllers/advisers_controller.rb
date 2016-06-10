class AdvisersController < ApplicationController
  def index
    @advisers = policy_scope(Adviser)
    authorize @advisers
  end
end
