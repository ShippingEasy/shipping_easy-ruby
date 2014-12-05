require "spec_helper"

describe ShippingEasy::Resources::Cancellation do
  describe ".create" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Cancellation.should_receive(:execute_request!).with({:relative_path=>"/stores/123456/orders/ABCXYZ/cancellations", :http_method=>:post}, :public)
      ShippingEasy::Resources::Cancellation.create(:store_api_key => "123456", external_order_identifier: "ABCXYZ")
    end
  end
end
