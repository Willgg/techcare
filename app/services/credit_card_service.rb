require 'stripe'

class CreditCardService
  def initialize
    @card = params[:stripeToken]
    @plan = params[:plan]
    @user = User.find(params[:user_id])
  end

  def create_customer
    begin
      external_customer_service.create(customer_attributes)
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    rescue => e
      # Something else happened, completely unrelated to Stripe
    end
  end

  private
  attr_reader :card, :plan, :user

  def external_customer_service
    Stripe::Customer
  end

  def customer_attributes
    {
      plan: plan,
      source: card,
      email: user.email,
      tax_percent: Pricing::TAX
    }
  end

end
