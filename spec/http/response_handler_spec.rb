require "spec_helper"

describe ShippingEasy::Http::ResponseHandler do

  let(:status) { 200 }
  let(:body) { { "order_number" => "12345" }}
  let(:response) do
    double("response",
            status: status,
            body: body.to_json)
  end

  subject { ShippingEasy::Http::ResponseHandler.new(response) }

  describe "#run" do
    context "when success" do
      specify { subject.run.should == body }
    end
    context "when request is invalid" do
      let(:status) { 400 }
      specify { expect { subject.run }.to raise_error(ShippingEasy::InvalidRequestError) }
    end
    context "when authentication fails" do
      let(:status) { 401 }
      specify { expect { subject.run }.to raise_error(ShippingEasy::AccessDeniedError) }
    end
    context "when resource cannot be found" do
      let(:status) { 404 }
      specify { expect { subject.run }.to raise_error(ShippingEasy::ResourceNotFoundError) }
    end
    context "when unexpected error occurs" do
      let(:status) { 500 }
      specify { expect { subject.run }.to raise_error(ShippingEasy::Error) }
    end
  end

end
