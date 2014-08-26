class ShippingEasy::Resources::SubscriptionPlan < ShippingEasy::Resources::Base
  command :find_all, request_type: :partner do |args|
    "/subscription_plans"
  end
end
