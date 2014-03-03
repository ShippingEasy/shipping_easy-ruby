class ShippingEasy::Http::FaradayAdapter

  extend Forwardable

  def_delegators :request, :body, :parameters, :base_url, :http_method, :uri

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def connect!
    send(http_method)
  end

  def post
    connection.post do |req|
      req.url uri, parameters
      req.body = request.body
    end
  end

  def connection
    @connection ||= Faraday.new(url: base_url) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

end
