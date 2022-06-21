require 'faraday'

module Fakepay
  class Api
    def self.connection
      Faraday.new(
        url: 'https://www.fakepay.io',
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=#{authorization_token}"
        }
      )
    end

    def self.handle_response(response)
      return JSON.parse(response.body) if response.status == '200'

      raise ConnectionError.new(status: response.status)
    end
    
    def self.authorization_token
      Rails.application.credentials.fakepay_api_token
    end
  end
end