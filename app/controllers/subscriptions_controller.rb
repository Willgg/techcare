class SubscriptionsController < ApplicationController
  after_action :verify_authorized, except: :show

  def show
  end

  def create
  end

  def destroy
  end
end
