require 'spec_helper'

describe ShippingEasy::Signature do
  let(:api_secret) { "ABC12345" }
  let(:method) { :post }
  let(:path) { "/api/orders" }
  let(:params) { { test_param: "ABCDE", api_key: "123", api_signature: "XXX" } }
  let(:request_body) { { orders: { name: "Flip flops", cost: "10.00", shipping_cost: "2.00" } }.to_json.to_s }
  let(:method) { :post }

  let(:options) { {api_secret: api_secret, method: method, path: path, params: params, body: request_body} }
  subject { ShippingEasy::Signature.new(options) }

  describe "#initialize" do
    specify { subject.api_secret.should == api_secret }
    specify { subject.method.should == "POST" }
    specify { subject.path.should == path }
    specify { subject.body.should == request_body }
    specify { subject.params[:api_signature].should be_nil }

    it "does not modify the input hash" do
      expect(subject).to_not be_nil
      expect(options).to have_key(:api_secret)
      expect(options).to have_key(:method)
      expect(options).to have_key(:path)
      expect(options).to have_key(:params)
    end

    it "does not modify the passed in params hash" do
      expect(subject).to_not be_nil
      expect(params).to have_key :test_param
      expect(params).to have_key :api_key
      expect(params).to have_key :api_signature
    end

    it "the exposed params hash does not contain the api_signature" do
      params_without_signature = params.reject{|k,v| k == :api_signature}
      expect(subject.params).to eq params_without_signature
    end
  end

  describe "#plaintext" do
    specify { expect(subject.plaintext).to eq("POST&/api/orders&api_key=123&test_param=ABCDE&{\"orders\":{\"name\":\"Flip flops\",\"cost\":\"10.00\",\"shipping_cost\":\"2.00\"}}")}
  end

  describe "#encrypted" do
    specify { expect(subject.encrypted).to eq(OpenSSL::HMAC::hexdigest("sha256", api_secret, subject.plaintext))}
  end

  describe "#to_s" do
    specify { expect(subject.to_s).to eq(subject.encrypted)}
  end

  describe "#==" do
    let(:duplicate_signature) { ShippingEasy::Signature.new(api_secret: api_secret, method: method, path: path, params: params, body: request_body) }
    specify { expect(subject == OpenSSL::HMAC::hexdigest("sha256", api_secret, subject.plaintext)).to be_truthy }
    specify { expect(subject == OpenSSL::HMAC::hexdigest("sha256", "BADSECRET", subject.plaintext)).to be_falsey }
    specify { expect(subject == duplicate_signature).to be_truthy }
  end
end
