# Configuration class that stores configuration options for the ShippingEasy API.
#
# ShippingEasy requires an API key and secret combination to authenticate against its API. At the very least these must be
# supplied in the configuration.
#
# Configuration options are typically set via the ShippingEasy.config method.
# @see ShippingEasy.configure
# @example
#   ShippingEasy.configure do |config|
#     config.api_key = "12345"
#     config.api_secret = "XXXXXXXXXXXXXXXXXXXXXXXX"
#   end
#
module ShippingEasy
  class Configuration
    LEGACY_URL = "https://app.shippingeasy.com"
    DEFAULT_URL = "https://api.shippingeasy.com"

    attr_reader   :base_url
    attr_accessor :api_key,
                  :api_secret,
                  :partner_api_key,
                  :partner_api_secret,
                  :api_version,
                  :http_adapter

    # Creates a configuration object, setting the default attributes.
    def initialize
      @http_adapter = ShippingEasy::Http::FaradayAdapter
      @base_url = DEFAULT_URL
    end

    def base_url=(val)
      if val == LEGACY_URL
        @base_url = DEFAULT_URL
      else
        @base_url = val
      end
    end
  end
end
