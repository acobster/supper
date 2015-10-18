require 'shopify_api'
require 'supper/variant'

module Supper
  class Collection
    def self.get_variants collection_id, type=:smart
      map_to_variants get_products( collection_id, type )
    end

    def self.collection_class type
      type == :smart ? ShopifyAPI::SmartCollection : ShopifyAPI::CustomCollection
    end

    def self.map_to_variants products
      # Get a multidimensional array of wrapped variants and flatten it
      products.map do |product|
        product.variants.map do |variant|
          Variant.new variant, product
        end
      end.flatten
    end

    def self.get_products collection_id, type
      collection_class( type ).find( collection_id ).products
    end
  end
end