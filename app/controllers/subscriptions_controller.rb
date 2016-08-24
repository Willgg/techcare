class SubscriptionsController < ApplicationController
  after_action :verify_authorized, except: [:show, :new]

  def show
  end

  def new
    @subscription = Subscription.new
    @plan = params[:plan]
  end

  def create
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    plan  = params[:plan]

    # Create a Customer
    customer = Stripe::Customer.create(
                :source => token,
                :plan => plan,
                :email => current_user.email
               )
    raise
  end

  def destroy
  end
end
