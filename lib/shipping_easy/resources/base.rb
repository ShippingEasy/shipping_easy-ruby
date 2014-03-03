class ShippingEasy::Resources::Base

  def self.command(name, command_options, &block)
    define_singleton_method name do |options = {}|
      options[:relative_path] = command_options.fetch(:relative_path, block.call(options))
      options[:http_method] = command_options.fetch(:http_method, :get)
      execute_request!(options)
    end
  end

  def self.execute_request!(options = {})
    response = ShippingEasy::Http::Request.connect!(options)
    ShippingEasy::Http::ResponseHandler.run(response)
  end

end
