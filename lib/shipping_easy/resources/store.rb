class ShippingEasy::Resources::Store < ShippingEasy::Resources::Base

  command :find_all, http_method: :get do |args|
    '/stores'
  end

end