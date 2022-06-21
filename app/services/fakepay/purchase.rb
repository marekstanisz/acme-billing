module Fakepay
  class Purchase < Api
    def self.post(params)
      response = connection.post(endpoint) do |r|
        r.body = params.to_json
      end

      handle_response(response)
    end

    def self.endpoint
      '/purchase'
    end
  end
end