class ShippingEasy::Resources::RateQuote < ShippingEasy::Resources::Base

  command :fetch, request_type: :partner, http_method: :post do |args|
    "/rate_quote"
  end
end
