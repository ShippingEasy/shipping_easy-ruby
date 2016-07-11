class ShippingEasy::Http::Request

  attr_accessor :http_method, :body, :params, :relative_path

  def initialize(options = {})
    @http_method = options.fetch(:http_method, :get)
    @params = options.fetch(:params, {})
    @body = options[:payload] && options[:payload].to_json
    @relative_path = options.delete(:relative_path)
  end

  def self.connect!(options = {})
    new(options).connect!
  end

  def connect!
    sign_request!
    adapter.connect!
  end

  def sign_request!
    params[:api_key] = api_key
    params[:api_timestamp] = Time.now.to_i
    params[:api_signature] = signature.to_s
  end

  def uri
    "/api#{relative_path}"
  end

  def signature
    ShippingEasy::Signature.new(api_secret: api_secret, method: http_method, path: uri, params: params, body: body)
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

  def base_url
    ShippingEasy.base_url
  end

end
