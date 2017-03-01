class ShippingEasy::Resources::Partner < ShippingEasy::Resources::Base
  command :accounts, http_method: :post, request_type: :partner  do |args|
    '/accounts'
  end

  command :subscription_plans, http_method: :get, request_type: :partner do |args|
    '/subscription_plans'
  end
end