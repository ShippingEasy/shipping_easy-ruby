require "spec_helper"

describe ShippingEasy::Resources::Base do

  class GenericResource < ShippingEasy::Resources::Base; end

  describe ".command" do
    before { GenericResource.command(:create, method: :post) }

    it "defines a method on the class" do
      GenericResource.should respond_to(:create)
    end

    it "extracts options to send to a request" do

    end

    context "when a block is provided" do
      it "uses it as the value for the path" do
        GenericResource.command(:create, method: :post) do |args|
          "/this/is/the/path"
        end
        GenericResource.should_receive(:execute_request!).with({:path=>"/this/is/the/path", :http_method=>:get})
        GenericResource.create
      end

      context "and an argument is passed in" do
        it "interpolates it" do
          GenericResource.command(:create, method: :post) do |args|
            "/this/is/the/#{args.delete(:name)}"
          end
          GenericResource.should_receive(:execute_request!).with({:path=>"/this/is/the/ABC123", :http_method=>:get})
          GenericResource.create(name: "ABC123")
        end
      end
    end
  end

end
