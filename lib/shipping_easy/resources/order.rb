class ShippingEasy::Resources::Order < ShippingEasy::Resources::Base

  command :create, http_method: :post do |args|
    "/stores/#{args.delete(:store_api_key)}/orders"
  end

end
