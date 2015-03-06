require 'supper/collection'

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
