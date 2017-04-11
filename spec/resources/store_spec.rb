require "spec_helper"

describe ShippingEasy::Resources::Store do
  describe ".stores_api_info" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Store.should_receive(:execute_request!).with({:relative_path=>"/stores",
                                                                             :http_method=>:get},
                                                                            :public)
      ShippingEasy::Resources::Store.stores_api_info
    end
  end
end