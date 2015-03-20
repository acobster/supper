require 'spec_helper'
require 'supper/inventory'

RSpec.describe Supper::Inventory do
  include_context 'suppliers'

  let(:inventory) {
    inventory = Supper::Inventory.new
    [bobs_feed, janes_feed].each { |f| inventory.add_feed f }
    inventory
  }

  let(:bobs_feed)   { double('bobs_feed') }
  let(:janes_feed)  { double('janes_feed') }

  let(:bobs_inventory) do
    {
      'zero'  => 0,
      'one'   => 1,
      'two'   => 2,
      'three' => 3,
    }
  end

  let(:janes_inventory) do
    {
      'two'   => 2,
      'three' => 3,
      'four'  => 4,
    }
  end

  let(:compiled) do
    {
      'zero'  => 0,
      'one'   => 1,
      'two'   => 4,
      'three' => 6,
      'four'  => 4,
    }
  end

  let(:mock_supplier_inventories) do
    expect( bobs_feed ).to receive(:read).and_return(bobs_inventory)
    expect( janes_feed ).to receive(:read).and_return(janes_inventory)
  end

  def expect_inventory_levels_to_match expected, actual
    expected.each do |sku, quantity|
      expect( actual[sku] ).to eq quantity
    end
  end

  describe 'class methods' do
    describe '#build' do
      it 'returns an instance of Supper::Inventory' do
        expect( Supper::SupplierFeed ).to receive(:build).once.with('bob').
          and_return( bobs_feed )
        expect( Supper::SupplierFeed ).to receive(:build).once.with('jane').
          and_return( janes_feed )

        i = Supper::Inventory.build(['bob', 'jane'])
        expect(i).to be_a Supper::Inventory
      end
    end
  end

  describe '#fetch_all!' do
    it 'calls #copy_inventory_file! on each feed' do
      expect( bobs_feed ).to receive(:copy_inventory_file!).once
      expect( janes_feed ).to receive(:copy_inventory_file!).once
      inventory.fetch_all!
    end
  end

  describe '#compile' do
    it 'reads each feed into the compiled inventory' do
      mock_supplier_inventories
      inventory.compile
      expect_inventory_levels_to_match compiled, inventory
    end
  end

  describe '#[]' do
    let(:inventory) { Supper::Inventory.new compiled }

    it 'gets a quantity from its internal Hash' do
      expect_inventory_levels_to_match compiled, inventory
    end

    it 'returns nil if SKU not found' do
      ['foo', :bar, 123].each do |i|
        expect( inventory[i] ).to be_nil
      end
    end
  end
end
