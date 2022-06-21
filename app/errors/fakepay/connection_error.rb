module Fakepay
  class ConnectionError < StandardError
    attr_reader :status
    
    def initialize(status:)
      @status = status
    end
  end
end