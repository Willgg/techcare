module Hooks
  module Stripe
    class Hooks::Stripe::EventsController < ApplicationController

      protect_from_forgery :except => :charge_failed

      after_action :verify_authorized, except: [:charge_failed]

      def charge_failed
        # Stripe cycle => https://stripe.com/docs/subscriptions/lifecycle
        # Stripe doc => https://stripe.com/docs/api#create_charge
        if request.headers['Content-Type'] == 'application/json'
          data = JSON.parse(request.body.read)
        else
          data = params.as_json
        end
        # Webhook::Received.save(data: data, integration: params[:integration_name])
        render js: data.to_s
      end

    end
  end
end
