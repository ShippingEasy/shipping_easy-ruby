class ShippingEasy::Http::ResponseHandler

  extend Forwardable

  def_delegators :response, :status, :body

  attr_reader :response

  def initialize(response)
    @response = response
  end

  def self.run(response)
    new(response).run
  end

  def run
    case status
      when 401 then raise ShippingEasy::AccessDeniedError, response.body
      when 404 then raise ShippingEasy::ResourceNotFoundError, response.body
      when 200, 201 then JSON.parse(response.body)
      else
        raise ShippingEasy::Error, response.body
    end
  end

end
