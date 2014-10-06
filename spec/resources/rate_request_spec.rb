require "spec_helper"

describe ShippingEasy::Resources::RateQuote do
  describe ".fetch" do
    it "sends a request with the expected options" do

      ShippingEasy::Resources::RateQuote.should_receive(:execute_request!).with({:relative_path=>"/rate_quote",
                                                              :http_method=>:post,
                                                              :payload => {:carrier => "usps", 
                                                                          :carrier_service => "Priority",
                                                                          :packaging => 'custome',
                                                                          :weight => "7",
                                                                          :to_postal_code => "78717",
                                                                          :from_postal_code => "78746"
                                                              }}, :partner)

      ShippingEasy::Resources::RateQuote.fetch(payload: {:carrier => 'usps',
                                                 :carrier_service => "Priority",
                                                 :packaging => 'custome',
                                                 :weight => "7",
                                                 :to_postal_code => "78717",
                                                 :from_postal_code => "78746"}
                                                )
    end
  end
end

