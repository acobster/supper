#!/usr/bin/env ruby

SUPPER_ROOT = Dir.pwd

require File.join SUPPER_ROOT, 'autoload'

config = Supper::Config.new 'config.yml'
supper = Supper::Base.new config
supper.update_shopify_supplier_inventory!
