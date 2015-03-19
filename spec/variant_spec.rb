require 'spec_helper'
require 'supper/variant'

RSpec.describe Supper::Variant do
  include_context 'products'

  let(:tag_string) { 'Tag 1, Tag 2' }
  let(:tags) { ['Tag 1', 'Tag 2'] }

  before do
    allow_any_instance_of( ShopifyAPI::Product ).to receive(:tags).
      and_return( tag_string )
  end

  describe '#tags' do
    subject { variant.tags }

    context 'when tagged with nothing' do
      let(:tag_string) { '' }

      it 'returns an empty Array' do
        expect( subject ).to eq []
      end
    end

    context 'when tagged with something' do
      it 'returns an Array' do
        expect( subject ).to eq tags
      end
    end
  end

  describe '#tagged_with?' do

    context 'when tagged with the given tag' do
      it 'returns true' do
        tags.each do |tag|
          expect( variant ).to be_tagged_with tag
        end
      end
    end

    context 'when not tagged with the given tag' do
      let(:tags) { ['Foo', 'Bar'] }

      it 'returns false' do
        tags.each do |tag|
          expect( variant ).not_to be_tagged_with tag
        end
      end
    end
  end

  describe '#update_drop_ship_availability!' do
    let(:available) { Supper::Variant::POLICY_DROP_SHIP_AVAILABLE }
    let(:unavailable) { Supper::Variant::POLICY_DROP_SHIP_NOT_AVAILABLE }

    context 'when drop-ship availability has changed' do
      it 'calls #save!' do
        expect_any_instance_of( ShopifyAPI::Variant ).to receive( :save! ).
          once.
          and_return( true )

        expect( variant.inventory_policy ).to eq unavailable
        saved = variant.update_drop_ship_availability! true
        expect( saved ).to be true
      end
    end

    context 'when drop-ship availability has not changed' do
      it 'does not call #save!' do
        expect_any_instance_of( ShopifyAPI::Variant ).not_to receive :save!
        saved = variant.update_drop_ship_availability! false # unavailable
        expect( saved ).to be false
      end
    end
  end
end
