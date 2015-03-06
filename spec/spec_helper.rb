require 'yaml'

require_relative '../autoload'

def load_fixture file
  path = "spec/fixtures/#{file.to_s}.yml"
  YAML.load File.read path
end

RSpec.shared_context 'products' do
  [
    :api_collection,
    :api_products,
    :metafields,
  ].each do |fixture| let(fixture) { load_fixture fixture } end


  let(:supper_variants) do
    Supper::Collection.map_to_variants api_products
  end

  let(:variant) do
    supper_variants.first
  end
end

RSpec.shared_context 'suppliers' do
  let(:suppliers) { [supplier_bob, supplier_jane] }
  let(:supplier_bob) { double('supplier_bob') }
  let(:supplier_jane) { double('supplier_jane') }
end
