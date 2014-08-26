class ShippingEasy::Resources::Account < ShippingEasy::Resources::Base
  command :create, request_type: :partner, http_method: :post do |args|
    "/accounts"
  end
end
