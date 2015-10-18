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

  describe '#update_shopify_supplier_inventory!' do
    it 'updates multiple variants with correct values' do
      inventory = double('inventory')
      filter = double('filter')

      expect( Supper::Collection ).to receive(:get_variants).once.
        with( 1234567890, :smart ).and_return( variants )
      expect( Supper::Inventory ).to receive(:build).once.and_return( inventory )

      expect( inventory ).to receive(:fetch_all!).once
      expect( inventory ).to receive(:compile).once
      expect( inventory ).to receive(:to_h).once.and_return( {} )

      expect( Supper::VariantFilter ).to receive(:new).
        with( config, inventory ).and_return( filter )
      expect( filter ).to receive(:filter_variants).with(variants).and_return [variant1, variant2]

      expect( variant1 ).to receive(:sku).and_return 'SKU1'
      expect( inventory ).to receive(:[]).with( 'SKU1' ).and_return 0
      expect( variant1 ).to receive(:update_drop_ship_availability!).once.with false

      expect( variant2 ).to receive(:sku).and_return 'SKU2'
      expect( inventory ).to receive(:[]).with( 'SKU2' ).and_return 3
      expect( variant2 ).to receive(:update_drop_ship_availability!).once.with true

      expect( variant3 ).not_to receive :update_drop_ship_availability!
      expect( variant4 ).not_to receive :update_drop_ship_availability!

      # Logging stuff
      [variant1, variant2].each do |v|
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
