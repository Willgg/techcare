module Hooks

  class StripeController < ApplicationController

    protect_from_forgery except: :call
    skip_before_action :authenticate_user!
    skip_after_action :verify_authorized

    def call

      # Retrieving the event from the Stripe API guarantees its authenticity

      event = Stripe::Event.retrieve(params[:id])
      logger.info "Event reçu le " + Time.now.strftime("%m/%d/%Y @ %R") + " " +
                  event.data.object.inspect

      case event.type
      when 'invoice.payment_suceeded'
      when 'invoice.payment_failed'
        stripe_sub = event.data.object.lines.data.first
        sub = Subscription.find_by(stripe_id: stripe_sub.id)
        if stripe_sub.status == 'canceled' || stripe_sub.status == 'unpaid'
          sub.active = false
        else
          sub.active = true
        end
        if sub.save
          # send notification
        end
      end
      render text: 'success'
    end

  end
end
