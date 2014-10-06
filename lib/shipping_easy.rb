
require "faraday"
require "rack"
require "json"
require "shipping_easy/authenticator"
require "shipping_easy/configuration"
require "shipping_easy/signature"
require "shipping_easy/http"
require "shipping_easy/http/faraday_adapter"
require "shipping_easy/http/request"
require "shipping_easy/http/partner_request"
require "shipping_easy/http/response_handler"
require "shipping_easy/resources"
require "shipping_easy/resources/base"
require "shipping_easy/resources/order"
require "shipping_easy/resources/rate_quote"
require "shipping_easy/resources/cancellation"
require "shipping_easy/version"

module ShippingEasy

  class << self

    attr_accessor :configuration

    def configure
      configuration = ShippingEasy::Configuration.new
      yield(configuration)
      self.configuration = configuration
    end

    def api_secret
      return nil if configuration.nil?
      configuration.api_secret
    end

    def api_key
      return nil if configuration.nil?
      configuration.api_key
    end

    def partner_api_secret
      return nil if configuration.nil?
      configuration.partner_api_secret
    end

    def partner_api_key
      return nil if configuration.nil?
      configuration.partner_api_key
    end

    def base_url
      return nil if configuration.nil?
      configuration.base_url
    end
  end

  class Error < StandardError; end
  class ResourceNotFoundError < Error; end
  class InvalidRequestError < Error; end
  class RequestExpiredError < Error
    def initialize(msg = "The request has expired.")
      super(msg)
    end
  end

  class SessionExpiredError < Error
    def initialize(msg = "The client session has expired.")
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
