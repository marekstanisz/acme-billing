require 'faraday'

module Fakepay
  class Api
    ERROR_CODES = {
      1000001 => 'Provided credit card number is invalid',
      1000002 => 'You have insufficient funds',
      1000003 => 'The CVV provided is invalid',
      1000004 => 'Your card is expired',
      1000005 => 'The zip code provided is invalid'
    }

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
      response_body = parsed_response(response)
      return response_body if response.status == 200

      raise ConnectionError.new(message: error_message(response_body))
    end

    def self.parsed_response(response)
      JSON.parse(response.body)
    end

    def self.error_message(response)
      ERROR_CODES[response['error_code']]
    end
    
    def self.authorization_token
      Rails.application.credentials.fakepay_api_token
    end
  end
end