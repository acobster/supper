require 'spec_helper'
require 'supper/variant_filter'

RSpec.describe Supper::VariantFilter do
  include_context 'config'

  let(:variant1) { double('variant1') }
  let(:variant2) { double('variant2') }
  let(:variant3) { double('variant3') }
  let(:variant4) { double('variant4') }
  let(:variant5) { double('variant5') }
  let(:variants) { [variant1, variant2, variant3, variant4, variant5] }

  let(:inventory) { double('inventory') }

  let(:filter) { Supper::VariantFilter.new valid_config, inventory }

  describe '#filter_variants' do
    it 'excludes variants based on tags, SKU, and quantity' do
      expect( variant1 ).to receive(:tagged_with?).twice.and_return false
      expect( variant1 ).to receive(:sku).at_least(:once).and_return 'SKU'
      expect( inventory ).to receive(:[]).once.and_return 3

      expect( variant2 ).to receive(:tagged_with?).once.with('Exclude This Tag').and_return false
      expect( variant2 ).to receive(:tagged_with?).once.with('Exclude This Other Tag').and_return true

      expect( variant3 ).to receive(:tagged_with?).once.with('Exclude This Tag').and_return true
      
      expect( variant4 ).to receive(:tagged_with?).twice.and_return false
      expect( variant4 ).to receive(:sku).at_least(:once).and_return ''

      expect( variant5 ).to receive(:tagged_with?).twice.and_return false
      expect( variant5 ).to receive(:sku).at_least(:once).and_return 'SKUUU'
      expect( inventory ).to receive(:[]).once.and_return nil

      expect( filter.exclude_tags ).to eq ['Exclude This Tag', 'Exclude This Other Tag']
      expect( filter.filter_variants(variants) ).to eq [variant1]
    end
  end

  # describe '#update_drop_ship_availability!' do
  #   it 'updates multiple variants with correct values' do
  #     inventory = double('inventory')

  #     expect( Supper::Collection ).to receive(:get_variants).once.
  #       with( 1234567890, :smart ).and_return( variants )
  #     expect( Supper::Inventory ).to receive(:build).once.and_return( inventory )

  #     expect( inventory ).to receive(:fetch_all!).once
  #     expect( inventory ).to receive(:compile).once
  #     expect( inventory ).to receive(:to_h).once.and_return( {} )

  #     # Empty SKU: shouldn't check inventory
  #     expect( variant1 ).to receive(:sku).at_least(:once).and_return ''
  #     expect( variant1 ).not_to receive( :update_drop_ship_availability! )

  #     # Non-empty SKU, available:
  #     #  - check inventory with SKU
  #     #  - update with true
  #     expect( variant2 ).to receive(:sku).at_least(:once).and_return 'asdf'
  #     expect( inventory ).to receive(:[]).with('asdf').and_return 3
  #     expect( variant2 ).to receive( :update_drop_ship_availability! ).once.
  #       with(true)

  #     # Non-empty SKU, unavailable:
  #     #  - check inventory with SKU
  #     #  - update with false
  #     expect( variant3 ).to receive(:sku).at_least(:once).and_return 'foo bar'
  #     expect( inventory ).to receive(:[]).with('foo bar').and_return 0
  #     expect( variant3 ).to receive( :update_drop_ship_availability! ).once.
  #       with(false)

  #     # Non-empty SKU, missing from inventory:
  #     #  - check inventory with SKU
  #     #  - don't update
  #     expect( variant4 ).to receive(:sku).at_least(:once).and_return 'SKUUU'
  #     expect( inventory ).to receive(:[]).with('SKUUU').and_return nil
  #     expect( variant4 ).not_to receive( :update_drop_ship_availability! )

  #     # Logging stuff
  #     [variant1, variant2, variant3, variant4].each do |v|
  #       expect(v).to receive(:to_h).once.and_return({})
  #       allow(v).to receive(:updated?).once.and_return(false) # this just
  #     end
  #     file = double('file')
  #     expect( File ).to receive(:open).once.and_return(file)
  #     expect( file ).to receive(:write).once
  #     expect( file ).to receive(:close).once

  #     supper.update_shopify_supplier_inventory!
  #   end
  # end
end
