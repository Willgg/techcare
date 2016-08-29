# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  user_id    :integer
#  active     :boolean          default(FALSE)
#  stripe_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#

class Subscription < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :name, :start_date, :stripe_id
  validates :name, inclusion: { in: [ "sub-1" , "sub-3", "sub-6" ]}

  def create_stripe_sub(options)
    token = options[:token]
    plan = options[:plan]

    begin
      customer = Stripe::Customer.create(source: token,
                                         plan: plan,
                                         email: user.email)
      self.stripe_id = customer.subscriptions["data"][0]["id"]
      self.active = true
      self.start_date = Time.current
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

  def get_stripe_plan
    Stripe::Plan.retrieve(name)
  end

  def get_stripe_sub
    Stripe::Subscription.retrieve(stripe_id)
  end
end
