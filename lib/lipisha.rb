require "lipisha/version"
require "active_support"
require 'active_support/core_ext/hash/indifferent_access'
require "json"
require 'faraday'

module Lipisha
  include ActiveSupport::Configurable
  config_accessor :logger

  autoload :SendMoney, 'lipisha/send_money'
end
Lipisha.configure do |c|
  c.api_type    = 'Callback'
  c.api_version = '1.3.0'
end
