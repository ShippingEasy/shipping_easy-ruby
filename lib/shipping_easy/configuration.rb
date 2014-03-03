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

    attr_accessor :api_key,
                  :api_secret,
                  :api_version,
                  :base_url,
                  :http_adapter

    # Creates a configuration object, setting the default attributes.
    def initialize
      @http_adapter = ShippingEasy::Http::FaradayAdapter
      @base_url = "https://app.shippingeasy.com"
    end
  end
end
