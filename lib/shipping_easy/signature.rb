module ShippingEasy

  # Used to generate ShippingEasy API signatures or to compare signature with one another.
  class Signature

    attr_reader :api_secret,
                :method,
                :path,
                :params,
                :body

    # Creates a new API signature object.
    #
    # options - The Hash options used to create a signature:
    #           :api_secret - A ShippingEasy-supplied API secret
    #           :method - The HTTP method used in the request. Either :get or :post. Default is :get.
    #           :path - The URI path of the request. E.g. "/api/orders"
    #           :params - The query params passed in as part of the request.
    #           :body - The body of the request which should normally be a JSON payload.
    #
    def initialize(options = {})
      @api_secret = options.delete(:api_secret) || ""
      @method = options.fetch(:method, :get).to_s.upcase
      @path = options.delete(:path) || ""
      @body = options.delete(:body) || ""
      @params = options.delete(:params) || {}
      @params.delete(:api_signature) # remove for convenience
    end

    # Concatenates the parts of the base signature into a plaintext string using the following order:
    #
    # 1. Capitilized method of the request. E.g. "POST"
    # 2. The URI path
    # 3. The query parameters sorted alphabetically and concatenated together into a URL friendly format: param1=ABC&param2=XYZ
    # 4. The request body as a string if one exists
    #
    # All parts are then concatenated together with an ampersand. The result resembles something like this:
    #
    # "POST&/api/orders&param1=ABC&param2=XYZ&{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}"
    #
    # Returns a correctly contenated plaintext API signature.
    def plaintext
      parts = []
      parts << method
      parts << path
      parts << Rack::Utils.build_query(params.sort)
      parts << body.to_s unless body.nil? || body == ""
      parts.join("&")
    end

    # Encrypts the plaintext signature with the supplied API secret. This signature should be included
    # when making a ShippingEasy API call.
    #
    # Returns an encrypted signature.
    def encrypted
      OpenSSL::HMAC::hexdigest("sha256", api_secret, plaintext)
    end

    # Equality operator to determine if another signature object, or string, matches the current signature. If a string is passed in, it
    # should represent the encrypted form of the API signature, not the plaintext version.
    #
    # It uses a constant time string comparison function to limit the vulnerability of timing attacks.
    #
    # Returns true if the supplied string or signature object matches the current object.
    def ==(other_signature)
      expected_signature, supplied_signature = self.to_s, other_signature.to_s
      return false if expected_signature.blank? || supplied_signature.blank? || expected_signature.bytesize != supplied_signature.bytesize
      l = expected_signature.unpack "C#{expected_signature.bytesize}"
      res = 0
      supplied_signature.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    # Returns the encrypted form of the signature.
    #
    # Returns an encrypted signature.
    def to_s
      encrypted
    end

  end
end
