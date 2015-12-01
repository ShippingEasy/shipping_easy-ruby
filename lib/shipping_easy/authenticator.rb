module ShippingEasy

  # Authenticates a signed ShippingEasy API request by matching the supplied signature with a freshly calculated one using the API
  # shared secret. Requests may not be more than 10 minutes old in order to prevent playback attacks.
  class Authenticator

    EXPIRATION_INTERVAL = 60 * 60

    attr_reader :api_secret,
                :api_signature,
                :api_timestamp,
                :method,
                :path,
                :params,
                :body,
                :expected_signature

    # Creates a new API authenticator object.
    #
    # options - The Hash options used to authenticate the request:
    #           :api_secret - A ShippingEasy-supplied API secret
    #           :method - The HTTP method used in the request. Either :get or :post. Default is :get.
    #           :path - The URI path of the request. E.g. "/api/orders"
    #           :params - The query params passed in as part of the request.
    #           :body - The body of the request which should normally be a JSON payload.
    def initialize(options = {})
      @api_secret = options.fetch(:api_secret, ShippingEasy.api_secret)
      @method = options.fetch(:method, :get)
      @path = options.fetch(:path)
      @body = options.fetch(:body, nil)
      @params = options.fetch(:params, {})
      @api_signature = params.delete(:api_signature)
      @api_timestamp = params.fetch(:api_timestamp, nil).to_i
      @expected_signature = ShippingEasy::Signature.new(api_secret: @api_secret, method: @method, path: @path, params: @params, body: @body)
    end

    # Convenience method to instantiate an authenticator and authenticate a signed request.
    #
    # options - The Hash options used to authenticate the request:
    #           :api_secret - A ShippingEasy-supplied API secret
    #           :method - The HTTP method used in the request. Either :get or :post. Default is :get.
    #           :path - The URI path of the request. E.g. "/api/orders"
    #           :params - The query params passed in as part of the request.
    #           :body - The body of the request which should normally be a JSON payload.
    #
    # See #authenticate for more detail.
    def self.authenticate(options = {})
      new(options).authenticate
    end

    # Authenticates the signed request.
    #
    # Example:
    #
    # authenticator = ShippingEasyShippingEasy::Authenticator.new(api_secret: "XXX",
    #                                                    method: :post,
    #                                                    path: "/api/orders",
    #                                                    params: { test_param: "ABCDE", api_key: "123", api_timestamp: "2014-01-03 10:41:21 -0600" },
    #                                                    body: "{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}")
    #
    # Throws ShippingEasyShippingEasy::RequestExpiredError if the API timestamp is expired.
    # Throws ShippingEasyShippingEasy::AccessDeniedError if the signature cannot be verified.
    # Throws ShippingEasyShippingEasy::TimestampFormatError if the timestamp format is invalid
    #
    # Returns true if authentication passes.
    def authenticate
      raise ShippingEasy::RequestExpiredError if request_expired?
      raise ShippingEasy::AccessDeniedError unless signatures_match?
      true
    end

    # Returns true if the signature included in the request matches our calculated signature.
    def signatures_match?
      expected_signature == api_signature
    end

    # Returns true if the supplied API timestamp has expired.
    def request_expired?
      parsed_timestamp < request_expires_at
    end

    # Returns the time that the request expires, given the supplied API timestamp.
    #
    # Returns a Time object.
    def request_expires_at
      Time.now - EXPIRATION_INTERVAL
    end

    # Parses the supplied API timestamp string into a Time object.
    #
    # Raises ShippingEasyShippingEasy::TimestampFormatError if the string cannot be converted into a Time object.
    # Returns a Time object.
    def parsed_timestamp
      raise ArgumentError if api_timestamp == 0
      Time.at(api_timestamp)
    rescue ArgumentError, TypeError
      raise ShippingEasy::TimestampFormatError
    end
  end
end
