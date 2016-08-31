class SubscriptionsController < ApplicationController

  before_action :find_subscription, only: [:edit, :destroy]
  before_action :find_user, only: [:edit, :destroy]
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def index
  end

  def new
    if current_user.subscription
      @subscription = current_user.subscription
      authorize @subscription
      redirect_to edit_user_subscription_path(current_user, @subscription)
    else
      unless ['sub-1', 'sub-3', 'sub-6'].include?(params[:plan])
        flash[:alert] = "Cet abonnement n'existe pas. Veuillez choisir un des abonnements ci-dessous."
        redirect_to subscriptions_path
      end
      @subscription = Subscription.new(name: params[:plan])
      authorize @subscription
    end
  end

  def create
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    token = params[:stripeToken]
    name  = params[:plan]

    @subscription = Subscription.new(user_id: current_user.id, name: name)
    @subscription.create_stripe_sub(token: token, plan: name)
    authorize @subscription

    if @subscription.save
      flash[:notice] = "Votre moyen de paiement a bien été enregistré. Bienvenue!"
      if current_user.adviser_id.nil?
        redirect_to advisers_path
      else
        user_goals_path(current_user)
      end
    else
      flash[:alert] = "Votre moyen de paiement n'a pas été enregistré."
      render :new
    end
  end

  def edit
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @stripe_sub = @subscription.get_stripe_sub
    @plan = @stripe_sub.plan
    @time = Time.at(@stripe_sub.trial_end)
    @trial_left = (@stripe_sub.trial_end - @stripe_sub.trial_start) / (60*60*24)
    authorize @subscription
  end

  def update
  end

  def destroy
  end

  private

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def skip_pundit?
    devise_controller? ||
    params[:controller] =~ /(^(active_)?admin)|(^pages$)/ ||
    params[:controller] = 'subscriptions'
  end
end
