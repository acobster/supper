require 'spec_helper'

RSpec.describe Supper::Collection do
  include_context 'products'

  let(:collection_id) { 1234 }
  let(:type) { :smart }

  let(:mock_collection) do
    expect( ShopifyAPI::SmartCollection ).to receive( :find ).
      with( collection_id ).
      and_return( api_collection )
  end

  let(:mock_collection_products) do
    expect_any_instance_of( ShopifyAPI::SmartCollection ).to receive( :products ).
      and_return( api_products )
  end

  describe 'class methods' do
    describe '#get_variants' do
      before do
        mock_collection
        mock_collection_products
      end

      it 'returns an array of product variants' do
        variants = Supper::Collection.get_variants collection_id

        expect( variants ).to be_an Array
        expect( variants ).to all be_a Supper::Variant
      end
    end

    describe '#get_products' do
      before do
        mock_collection
        mock_collection_products
      end

      it 'returns an array of products' do
        products = Supper::Collection.get_products collection_id, type

        expect( products ).to be_an Array
        expect( products ).to all be_a ShopifyAPI::Product
      end
    end

    describe '#collection_class' do
      subject { Supper::Collection.collection_class type }

      context 'smart' do
        # type defaults to :smart

        it 'returns a Shopify Collection Class' do
          expect( subject ).to eq ShopifyAPI::SmartCollection
        end
      end

      context 'custom' do
        let(:type) { :custom }

        it 'returns a Shopify Collection Class' do
          expect( subject ).to eq ShopifyAPI::CustomCollection
        end
      end
    end
  end
end