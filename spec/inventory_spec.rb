require 'spec_helper'
require 'supper/inventory'

RSpec.describe Supper::Inventory do
  include_context 'suppliers'

  it 'has inventory' do
    expect( Supper::SupplierFeed ).to receive(:build).twice
    Supper::Inventory.build suppliers
  end
end