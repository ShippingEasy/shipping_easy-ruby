# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipping_easy/version'

Gem::Specification.new do |spec|
  spec.name          = "shipping_easy"
  spec.version       = ShippingEasy::VERSION
  spec.authors       = ["ShippingEasy"]
  spec.email         = ["dev@shippingeasy.com"]
  spec.description   = "The official ShippingEasy API client for Ruby."
  spec.summary       = "The official ShippingEasy API client for Ruby."
  spec.homepage      = "https://github.com/ShippingEasy/shipping_easy-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('faraday', '>= 1.0.0')
  spec.add_dependency('faraday_middleware', '~> 1.0.0')
  spec.add_dependency('rack', ">= 1.4.5")
  spec.add_dependency('json', ">= 2.3.0")
  spec.add_development_dependency "bundler", "~> 2.4.10"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rake"
end
