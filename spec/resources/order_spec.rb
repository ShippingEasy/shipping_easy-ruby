require "spec_helper"

describe ShippingEasy::Resources::Order do

  describe ".find_all" do
    context "when store ID is not included" do
      it "sends a request with the expected options" do
        expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/orders",
                                                                                :http_method => :get,
                                                                                :params => { :page => 2,
                                                                                             :per_page => 3,
                                                                                             :status => [:shipped] } }, :public)

        ShippingEasy::Resources::Order.find_all(:page => 2, :per_page => 3, :status => [:shipped])
      end
    end

    context "when store ID is included" do
      it "sends a request with the expected options" do
        expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/stores/123456/orders",
                                                                                :http_method => :get,
                                                                                :params => { :page => 2,
                                                                                             :per_page => 3,
                                                                                             :status => [:shipped] } }, :public)

        ShippingEasy::Resources::Order.find_all(:store_api_key => "123456", :page => 2, :per_page => 3, :status => [:shipped])
      end
    end
  end

  describe ".find" do
    context "when store ID is not included" do
      it "sends a request with the expected options" do
        expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/orders/2", :http_method => :get }, :public)
        ShippingEasy::Resources::Order.find(:id => 2)
      end
    end

    context "when store ID is included" do
      it "sends a request with the expected options" do
        expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/stores/123456/orders/2", :http_method => :get }, :public)
        ShippingEasy::Resources::Order.find(:store_api_key => "123456", :id => 2)
      end
    end
  end

  describe ".create" do
    it "sends a request with the expected options" do
      expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/stores/123456/orders", :http_method => :post, payload: { name: "Jack" } }, :public)
      ShippingEasy::Resources::Order.create(:store_api_key => "123456", payload: { name: "Jack" })
    end
  end

  describe ".update_recipient" do
    let(:payload) do
      { recipient: { first_name: "Jack" } }
    end

    it "sends a request with the expected options" do
      expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/stores/123456/orders/2/recipient", :http_method => :put, payload: payload}, :public)
      ShippingEasy::Resources::Order.update_recipient(:store_api_key => "123456", id: 2, payload: payload)
    end
  end

  describe ".change_status" do
    let(:payload) do
      { order: { status: "shipped" } }
    end

    it "sends a request with the expected options" do
      expect(ShippingEasy::Resources::Order).to receive(:execute_request!).with({ :relative_path => "/stores/123456/orders/2/status", :http_method => :put, payload: payload}, :public)
      ShippingEasy::Resources::Order.update_status(:store_api_key => "123456", id: 2, payload: payload)
    end
  end
end
