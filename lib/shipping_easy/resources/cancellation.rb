class ShippingEasy::Resources::Cancellation < ShippingEasy::Resources::Base

  command :create, http_method: :post do |args|
    "/stores/#{args.delete(:store_api_key)}/orders/#{args.delete(:external_order_identifier)}/cancellations"
  end

end
