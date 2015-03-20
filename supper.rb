#!/usr/bin/env ruby

require_relative 'load_path.rb'
require 'supper/base'

config = Supper::Config.load_from_file( ARGV[0] || 'config.yml' )
supper = Supper::Base.new config
supper.update_shopify_supplier_inventory!
