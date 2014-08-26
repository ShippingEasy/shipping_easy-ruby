class ShippingEasy::Resources::Base

  def self.command(name, command_options = {}, &block)
    define_singleton_method name do |options = {}|
      request_options = {}
      request_options[:relative_path] = command_options.fetch(:relative_path, block.call(options))
      request_options[:http_method] = command_options.fetch(:http_method, :get)
      request_options[:payload] = options.delete(:payload) if options.has_key?(:payload)
      request_options[:params] = options unless options.nil? || options.empty?
      execute_request!(request_options, command_options.fetch(:request_type, :public))
    end
  end

  def self.execute_request!(options = {}, request_type)
    request_class = request_type == :partner ? ShippingEasy::Http::PartnerRequest : ShippingEasy::Http::Request
    response = request_class.connect!(options)
    ShippingEasy::Http::ResponseHandler.run(response)
  end

end
