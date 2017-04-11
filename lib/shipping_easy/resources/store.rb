class ShippingEasy::Resources::Store < ShippingEasy::Resources::Base

  command :stores_api_info, http_method: :get do |args|
    '/stores'
  end

end