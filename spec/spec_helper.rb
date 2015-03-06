$LOAD_PATH.unshift( File.join(Dir.pwd, 'spec'), File.join(Dir.pwd, 'lib') )

require 'yaml'
require 'shared/products_context.rb'
require 'shared/suppliers_context.rb'

def load_fixture file
  path = "spec/fixtures/#{file.to_s}.yml"
  YAML.load File.read path
end
