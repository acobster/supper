require 'shopify_api'

module Supper
  class Base
    APP_TYPE_PRIVATE = 'private'

    def initialize config
      @config = config
      shop = @config.shopify

      if shop.app_type != APP_TYPE_PRIVATE
        raise 'Sorry, only private apps are currently supported...'
      end

      cred = "#{shop.api_key}:#{shop.api_password}@#{shop.shop_name}"
      ShopifyAPI::Base.site =
        "https://#{cred}.myshopify.com/admin"
    end

    def update_shopify_supplier_inventory!
      # Get Shopify Products via Collection API
      products = Product.get_variants_from_collection @config.shopify.collection_id,
        @config.shopify.collection_type.to_sym

      # Get supplier inventory from all feeds
      inventory = SupplierInventory.new
      @config.suppliers.each do |supplier|
        inventory.add_feed supplier
      end
      inventory.compile!

      # Update each product based on inventory
      products.each do |product|

      end
    end
  end
end