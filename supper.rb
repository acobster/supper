#!/usr/bin/env ruby

require_relative 'load_path.rb'

require 'supper/base'
require 'supper/config'

config = Supper::Config.new 'config.yml'
supper = Supper::Base.new config
supper.update_shopify_supplier_inventory!
