require 'faraday_middleware'
class ShippingEasy::Http::FaradayAdapter

  extend Forwardable

  def_delegators :request, :body, :params, :base_url, :http_method, :uri

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def connect!
    send(http_method)
  end

  def post
    connection.post do |req|
      req.url uri, params
      req.body = request.body
    end
  end

  def get
    connection.get do |req|
      req.url uri, params
      req.body = request.body
    end
  end

  def connection
    @connection ||= Faraday.new(url: base_url) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, limit: 3, standards_compliant: true
      faraday.adapter Faraday.default_adapter
    end
  end

end
