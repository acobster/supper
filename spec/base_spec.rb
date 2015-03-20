require 'spec_helper'
require 'supper/base'

RSpec.describe Supper::Base do
  let(:supper) { Supper::Base.new config }

  let(:config) do
    {
      'shopify' => {
        'api_key' => "asdf",
        'api_password' => "pass1234",
        'shop_name' => "my-shop",
        'collection_id' => 1234567890,
        'collection_type' => 'smart',
        'app_type' => 'private',
      },
      'suppliers' => {
        'alices' => {
          'ftp_host' => 'ftp.bobs.com',
          'ftp_port' => 212121,
          'ftp_user' => 'bobs_client',
          'ftp_password' => 'password',
          'ftp_inventory_file' => "Inventory/InventoryWeb.txt",
          'shopify_tag' => 'Bob',
          'inventory_format' => 'txt',
          'delim' => "\t",
          'sku_field' => 0,
          'quantity_field' => 3,
        }
      }
    }
  end

  let(:variant1) { double('variant1') }
  let(:variant2) { double('variant2') }
  let(:variant3) { double('variant3') }
  let(:variant4) { double('variant4') }
  let(:variants) { [variant1, variant2, variant3, variant4] }

  describe '#update_drop_ship_availability!' do
    it 'updates multiple variants with correct values' do
      inventory = double('inventory')

      expect( Supper::Collection ).to receive(:get_variants).once.
        with( 1234567890, :smart ).and_return( variants )
      expect( Supper::Inventory ).to receive(:build).once.and_return( inventory )

      expect( inventory ).to receive(:fetch_all!).once
      expect( inventory ).to receive(:compile).once
      expect( inventory ).to receive(:to_h).once.and_return( {} )

      # Empty SKU: shouldn't check inventory
      expect( variant1 ).to receive(:sku).once.and_return ''
      expect( variant1 ).not_to receive( :update_drop_ship_availability! )

      # Non-empty SKU, available:
      #  - check inventory with SKU
      #  - update with true
      expect( variant2 ).to receive(:sku).twice.and_return 'asdf'
      expect( inventory ).to receive(:[]).with('asdf').and_return 3
      expect( variant2 ).to receive( :update_drop_ship_availability! ).once.
        with(true)

      # Non-empty SKU, unavailable:
      #  - check inventory with SKU
      #  - update with false
      expect( variant3 ).to receive(:sku).twice.and_return 'foo bar'
      expect( inventory ).to receive(:[]).with('foo bar').and_return 0
      expect( variant3 ).to receive( :update_drop_ship_availability! ).once.
        with(false)

      # Non-empty SKU, missing from inventory:
      #  - check inventory with SKU
      #  - don't update
      expect( variant4 ).to receive(:sku).twice.and_return 'SKUUU'
      expect( inventory ).to receive(:[]).with('SKUUU').and_return nil
      expect( variant4 ).not_to receive( :update_drop_ship_availability! )

      # Logging stuff
      [variant1, variant2, variant3, variant4].each do |v|
        expect(v).to receive(:to_h).once.and_return({})
        allow(v).to receive(:updated?).once.and_return(false) # this just
      end
      file = double('file')
      expect( File ).to receive(:open).once.and_return(file)
      expect( file ).to receive(:write).once
      expect( file ).to receive(:close).once

      supper.update_shopify_supplier_inventory!
    end
  end
end
