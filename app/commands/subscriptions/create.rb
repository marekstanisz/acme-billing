require 'dry/monads'
require 'dry/monads/do'
require 'dry-schema'

module Subscriptions
  class Create
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    def call(params)
      transaction do
        values = yield validate(params)
        plan = yield fetch_plan(values.dig(:subscription, :plan_id))
        payment_token = yield bill_customer(plan, values[:billing])
        subscription = yield create_subscription(values[:subscription])

        Success(subscription)
      end
    end

    private

    def schema 
      Dry::Schema.Params do
        required(:subscription).filled(:hash).schema do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:address).filled(:string)
          required(:zip_code).filled(:string)
          required(:plan_id).filled(:string)
        end
        required(:billing).filled(:hash).schema do
          required(:card_number).filled(:string)
          required(:expiration_month).filled(:string)
          required(:expiration_year).filled(:string)
          required(:cvv).filled(:string)
          required(:zip_code).filled(:string)
        end
      end
    end

    def validate(params)
      schema.call(params)
    end

    def fetch_plan(plan_id)
      plan = Plan.find(plan_id)

      Success(plan)
    end

    def bill_customer(plan, billing_params)
      payment_token = Billing::Charge.new(plan, billing_params).call

      Success(payment_token)
    end

    def create_subscription(payment_token, subscription_params)
      subscription = Subscription.new(subscription_params)
      subscription.payment_token = payment_token
      subscription.next_billing_date = 1.month.from_now
      subscription.save!

      Success(subscription)
    end
  end
end