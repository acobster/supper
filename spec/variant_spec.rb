require 'spec_helper'

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

  describe '#update_policy!' do
    context 'when drop-ship availability has changed' do
      it 'calls #save!'
    end

    context 'when drop-ship availability has not changed' do
      it 'does not call #save!'
    end
  end
end
