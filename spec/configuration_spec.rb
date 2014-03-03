require "spec_helper"

describe ShippingEasy::Configuration do
  subject { ShippingEasy::Configuration.new }

  specify { subject.should respond_to(:api_key) }
  specify { subject.should respond_to(:api_secret) }
  specify { subject.should respond_to(:end_point) }

  describe "http_adapter" do
    it "gets set to a default" do
      subject.http_adapter.should == ShippingEasy::FaradayAdapter
    end

    it "can be overidden" do
      subject.http_adapter = String
      subject.http_adapter.should == String
    end
  end

  describe "end_point" do
    it "gets set to a default" do
      subject.http_adapter.should == ShippingEasy::FaradayAdapter
    end

    it "can be overidden" do
      subject.http_adapter = String
      subject.http_adapter.should == String
    end
  end
end
