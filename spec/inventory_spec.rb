require 'spec_helper'

RSpec.describe Supper::Inventory do
  include_context 'suppliers'

  it 'has inventory' do
    expect( Supper::SupplierFeed ).to receive(:build).twice
    Supper::Inventory.build suppliers
  end
end