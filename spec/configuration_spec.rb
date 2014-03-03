require "spec_helper"

describe ShippingEasy::Configuration do
  subject { ShippingEasy::Configuration.new }

  specify { subject.should respond_to(:api_key) }
  specify { subject.should respond_to(:api_secret) }
  specify { subject.should respond_to(:base_url) }

  describe "http_adapter" do
    it "gets set to a default" do
      subject.http_adapter.should == ShippingEasy::Http::FaradayAdapter
    end

    it "can be overidden" do
      subject.http_adapter = String
      subject.http_adapter.should == String
    end
  end

  describe "base_url" do
    it "gets set to a default" do
      subject.base_url.should == "https://app.shippingeasy.com"
    end

    it "can be overidden" do
      subject.base_url = String
      subject.base_url.should == String
    end
  end
end
