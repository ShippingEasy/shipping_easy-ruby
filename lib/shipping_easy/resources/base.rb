class ShippingEasy::Resources::Base

  def self.command(name, command_options = {}, &block)
    define_singleton_method name do |options = {}|
      request_options = {}
      request_options[:relative_path] = command_options.delete(:relative_path) || block.call(options)
      request_options[:http_method] = command_options.delete(:http_method) || :get
      request_options[:payload] = options.delete(:payload) if options.has_key?(:payload)
      request_options[:params] = options unless options.nil? || options.empty?
      execute_request!(request_options)
    end
  end

  def self.execute_request!(options = {})
    response = ShippingEasy::Http::Request.connect!(options)
    ShippingEasy::Http::ResponseHandler.run(response)
  end

end
