require 'spec_helper'

describe ShippingEasy::Signature do
  let(:api_secret) { "ABC12345" }
  let(:method) { :post }
  let(:path) { "/api/orders" }
  let(:params) { { test_param: "ABCDE", api_key: "123", api_signature: "XXX" } }
  let(:request_body) { { orders: { name: "Flip flops", cost: "10.00", shipping_cost: "2.00" } }.to_json.to_s }
  let(:method) { :post }

  subject { ShippingEasy::Signature.new(api_secret: api_secret, method: method, path: path, params: params, body: request_body) }

  describe "#initialize" do
    specify { subject.api_secret.should == api_secret }
    specify { subject.method.should == "POST" }
    specify { subject.path.should == path }
    specify { subject.body.should == request_body }
    specify { subject.params.should == params }
    specify { subject.params[:api_signature].should be_nil }
  end

  describe "#plaintext" do
    specify { subject.plaintext.should == "POST&/api/orders&api_key=123&test_param=ABCDE&{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}"}
  end

  describe "#encrypted" do
    specify { subject.encrypted.should == OpenSSL::HMAC::hexdigest("sha256", api_secret, subject.plaintext)}
  end

  describe "#to_s" do
    specify { subject.to_s.should == subject.encrypted}
  end

  describe "#==" do
    let(:duplicate_signature) { ShippingEasy::Signature.new(api_secret: api_secret, method: method, path: path, params: params, body: request_body) }
    specify { (subject == OpenSSL::HMAC::hexdigest("sha256", api_secret, subject.plaintext)).should be_true }
    specify { (subject == OpenSSL::HMAC::hexdigest("sha256", "BADSECRET", subject.plaintext)).should be_false }
    specify { (subject == duplicate_signature).should be_true }
  end
end
