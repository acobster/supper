$LOAD_PATH.unshift( File.join(Dir.pwd, 'spec'), File.join(Dir.pwd, 'lib') )

require 'debugger'
require 'yaml'
require 'recursive-open-struct'
require 'shared/products_context.rb'
require 'shared/config_context.rb'
require 'shared/suppliers_context.rb'
require 'shared/supplier_feed_examples.rb'

def load_fixture file
  path = "spec/fixtures/#{file.to_s}.yml"
  YAML.load File.read path
end
