class ShippingEasy::Resources::Session < ShippingEasy::Resources::Base
  command :create, request_type: :partner, http_method: :post do |args|
    "/sessions"
  end
end
