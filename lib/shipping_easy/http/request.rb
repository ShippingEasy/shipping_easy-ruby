class ShippingEasy::Http::Request

  attr_accessor :http_method, :body, :params, :path

  def initialize(options = {})
    @http_method = options.fetch(:http_method, :get)
    @params = options.fetch(:params, {})
    @body = options.delete(:body)
    @path = options.delete(:path)
  end

  def connect!
    sign_request!
    adapter.connect!
  end

  def sign_request!
    params[:api_signature] = signature.to_s
    params[:api_timestamp] = Time.now.to_i
  end

  def signature
    ShippingEasy::Signature.new(api_secret: api_secret, method: http_method, path: path, params: params, body: body)
  end

  def adapter
    ShippingEasy.configuration.http_adapter.new(self)
  end

  def api_secret
    ShippingEasy.api_secret
  end

  def api_key
    ShippingEasy.api_key
  end

end
