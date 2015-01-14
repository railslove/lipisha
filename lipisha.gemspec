# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lipisha/version'

Gem::Specification.new do |spec|
  spec.name          = "lipisha"
  spec.version       = Lipisha::VERSION
  spec.authors       = ["Michael Bumann"]
  spec.email         = ["michael@railslove.com"]
  spec.description   = %q{API wrapper for the Lipisha API. Currently supporting the send_money and confirm_transactions endpoints.}
  spec.summary       = %q{API wrapper for Lipisha}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

end
