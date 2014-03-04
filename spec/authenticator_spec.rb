require 'spec_helper'

describe ShippingEasy::Authenticator, api: true do
  let(:api_secret) { "ABC12345" }
  let(:method) { :post }
  let(:path) { "/api/orders" }
  let(:api_signature) { signature.to_s }
  let(:api_timestamp) { (Time.now - (60 * 5)).to_i }
  let(:params) { { test_param: "ABCDE", api_key: "123", api_timestamp: api_timestamp } }
  let(:params_with_signature) { params[:api_signature] = api_signature; params }
  let(:request_body) { { orders: { name: "Flip flops", cost: "10.00", shipping_cost: "2.00" } }.to_json.to_s }
  let(:method) { :post }
  let(:signature) { ShippingEasy::Signature.new(api_secret: api_secret, method: method, path: path, params: params, body: request_body) }
  subject { ShippingEasy::Authenticator.new(api_secret: api_secret, method: method, path: path, params: params_with_signature, body: request_body) }

  before do
    ShippingEasy.configure do |config|
      config.api_secret = api_secret
    end
  end

  describe "#initialize" do
    specify { subject.api_secret.should == api_secret }
    specify { subject.method.should == :post }
    specify { subject.path.should == path }
    specify { subject.body.should == request_body }
    specify { subject.params.should == params_with_signature }
    specify { subject.params[:api_signature].should be_nil }
    specify { subject.expected_signature.should be_a(ShippingEasy::Signature) }
  end

  context "when api_secret is not supplied" do
    subject { ShippingEasy::Authenticator.new(api_secret: api_secret, method: method, path: path, params: params_with_signature, body: request_body) }
    specify { subject.api_secret.should == api_secret }
  end

  describe "#request_expires_at" do
    specify { subject.request_expires_at.to_s.should == (Time.now - ShippingEasy::Authenticator::EXPIRATION_INTERVAL).to_s }
  end

  describe "#request_expired?" do
    specify { subject.request_expired?.should be_false }

    context "when expired" do
      let(:api_timestamp) { (Time.now - (ShippingEasy::Authenticator::EXPIRATION_INTERVAL * 2)).to_i }
      specify { subject.request_expired?.should be_true }
    end
  end

  describe "#signatures_match?" do
    specify { subject.signatures_match?.should be_true }

    context "when they don't match" do
      let(:api_signature) { "XXX" }
      specify { subject.signatures_match?.should be_false }
    end
  end

  describe "#parsed_timestamp" do
    specify { subject.parsed_timestamp.should be_a(Time) }
    context "when date string is invalid"  do
      let(:api_timestamp) { "xxxx" }
      specify { expect{ subject.parsed_timestamp }.to raise_error(ShippingEasy::TimestampFormatError) }
    end
  end

  describe "#authenticate" do
    context "when everything is ok" do
      before do
        subject.stub(:request_expired?).and_return(false)
        subject.stub(:signatures_match?).and_return(true)
      end
      specify { subject.authenticate.should be_true }
    end

    context "when request has expired" do
      before { subject.stub(:request_expired?).and_return(true) }
      specify { expect{ subject.authenticate }.to raise_error(ShippingEasy::RequestExpiredError)}
    end

    context "when signatures do not match" do
      before { subject.stub(:signatures_match?).and_return(false) }
      specify { expect{ subject.authenticate }.to raise_error(ShippingEasy::AccessDeniedError) }
    end
  end

end
