require 'shopify_api'

require 'supper/collection'
require 'supper/config'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'
require 'supper/inventory'
require 'supper/variant'

module Supper
  class Base
    APP_TYPE_PRIVATE = 'private'
    TIME_FORMAT = '%F-%H%M%S'
    DEFAULT_LOG_DIR = 'log'

    attr_accessor :log_dir

    def initialize config
      @config = config
      shop = @config['shopify']

      if shop['app_type'] != APP_TYPE_PRIVATE
        raise 'Sorry, only private apps are currently supported...'
      end

      self.log_dir = @config['log_dir'] || DEFAULT_LOG_DIR
      @log = { time: Time.now.strftime(TIME_FORMAT) }

      cred = "#{shop['api_key']}:#{shop['api_password']}@#{shop['shop_name']}"
      ShopifyAPI::Base.site = "https://#{cred}.myshopify.com/admin"
    end

    def update_shopify_supplier_inventory!
      # Get Shopify Products via Collection API
      variants = Collection.get_variants @config['shopify']['collection_id'],
        @config['shopify']['collection_type'].to_sym
      @log[:variants] = variants.map(&:to_h)

      # Get supplier inventory from all feeds
      inventory = Inventory.build @config['suppliers']
      inventory.fetch_all!
      inventory.compile
      @log[:inventory] = inventory.to_h

      # Update each product/variant based on inventory
      variants.each do |variant|
        unless variant.sku.empty?
          quantity = inventory[variant.sku]
          unless quantity.nil?
            variant.update_drop_ship_availability! (quantity > 0)
          end
        end
      end
    rescue Exception => e
      puts e.message
      @log[:error] = e.message
    ensure
      write_log_file
    end


    protected

    def write_log_file
      f = File.open File.join(log_dir, @log[:time]+'.json'), 'w'
      f.write @log.to_json
      f.close
    end
  end
end
