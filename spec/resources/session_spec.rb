require "spec_helper"

describe ShippingEasy::Resources::Session do
  describe ".create" do
    it "sends a request with the expected options" do

      ShippingEasy::Resources::Session.should_receive(:execute_request!).with({:relative_path=>"/sessions",
                                                                                 :http_method=>:post,
                                                                                 :payload => {session: { external_identifier: "ABC123",
                                                                                               email: "test@shippingeasy.com",
                                                                                               name: "Test Inc." }}}, :partner)

      ShippingEasy::Resources::Session.create(payload: { session: { external_identifier: "ABC123",
                                                        email: "test@shippingeasy.com",
                                                        name: "Test Inc." }})
    end
  end
end

