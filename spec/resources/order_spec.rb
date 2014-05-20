require "spec_helper"

describe ShippingEasy::Resources::Order do

  describe ".find_all" do
    it "sends a request with the expected options" do

      ShippingEasy::Resources::Order.should_receive(:execute_request!).with({:relative_path=>"/orders",
                                                              :http_method=>:get,
                                                              :params => {:page => 2,
                                                                          :per_page => 3,
                                                                          :status => [:shipped]}})

      ShippingEasy::Resources::Order.find_all(:page => 2, :per_page => 3, :status => [:shipped])
    end
  end

  describe ".find" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Order.should_receive(:execute_request!).with({:relative_path=>"/orders/2", :http_method=>:get})
      ShippingEasy::Resources::Order.find(:id => 2)
    end
  end

  describe ".create" do
    it "sends a request with the expected options" do
      ShippingEasy::Resources::Order.should_receive(:execute_request!).with({:relative_path=>"/stores/123456/orders", :http_method=>:post, payload: { name: "Jack" }})
      ShippingEasy::Resources::Order.create(:store_api_key => "123456", payload: { name: "Jack" })
    end
  end
end
