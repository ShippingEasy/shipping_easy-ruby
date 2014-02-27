require 'rack'
require "shipping_easy/version"

module ShippingEasy

  class Error < StandardError; end

  class RequestExpiredError < Error
    def initialize(msg = "The request has expired.")
      super(msg)
    end
  end

  class AccessDeniedError < Error
    def initialize(msg = "Access denied.")
      super(msg)
    end
  end

  class TimestampFormatError < Error
    def initialize(msg = "The API timestamp could not be parsed.")
      super(msg)
    end
  end
end
