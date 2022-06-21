module Billing
  class Charge
    def initialize(plan, params)
      @params = prepare_params(plan, params)
    end

    def call
      perform_request
      parse_response
    end

    private

    attr_reader :params, :response

    def prepare_params(plan, params)
      params.merge(amount: plan.price_in_cents)
    end

    def perform_request
      @response = Fakepay::Purchase.post(params)
    end

    def parse_response
    end
  end
end