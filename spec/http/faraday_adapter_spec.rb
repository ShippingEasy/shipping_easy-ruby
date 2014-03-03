require "spec_helper"

describe ShippingEasy::Http::FaradayAdapter do

  let(:http_method) { "post" }
  let(:params) { { "page" => 1 } }
  let(:base_url) { "https://www.test.com" }
  let(:uri) { "/api/orders" }
  let(:body) { { order_number: "1234" }.to_json }

  let(:request) do
    double("request",
            http_method: http_method,
            params: params,
            base_url: base_url,
            uri: uri,
            body: body)
  end

  subject { ShippingEasy::Http::FaradayAdapter.new(request) }

  [:http_method, :params, :base_url, :uri, :body].each do |m|
    it "delegates #{m} to request" do
      subject.send(m).should == request.send(m)
    end
  end

  describe "#connect!" do
    it "calls the correct http method as specified by the request" do
      subject.stub(:post)
      subject.should_receive(:post).once
      subject.connect!
    end
  end

  describe "#connection" do
    it "instantiates a faraday connection" do
      subject.connection.should be_a(Faraday::Connection)
    end
  end

end
