require 'rubygems'
require 'bundler/setup'
require 'shopify_api'

require 'supper/collection'
require 'supper/config'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'
require 'supper/inventory'
require 'supper/variant'
require 'supper/variant_filter'

module Supper
  class Base
    APP_TYPE_PRIVATE = 'private'
    TIME_FORMAT = '%F-%H%M%S'
    DEFAULT_PRETTY_TIME_FORMAT = '%l:%M%P %F'
    DEFAULT_LOG_DIR = 'log'

    attr_accessor :log_dir

    def initialize config
      @config = config
      shop = @config['shopify']

      if shop['app_type'] != APP_TYPE_PRIVATE
        raise 'Sorry, only private apps are currently supported...'
      end

      self.log_dir = @config['log_dir'] || DEFAULT_LOG_DIR
      now = Time.now
      @log = {
        time: now.strftime(TIME_FORMAT),
        pretty_time: now.strftime(DEFAULT_PRETTY_TIME_FORMAT),
      }

      cred = "#{shop['api_key']}:#{shop['api_password']}@#{shop['shop_name']}"
      ShopifyAPI::Base.site = "https://#{cred}.myshopify.com/admin"

      @seconds_between_calls = @config['seconds_between_calls'] || 0
    end

    def update_shopify_supplier_inventory!
      # Get Shopify Products via Collection API
      variants = Collection.get_variants @config['shopify']['collection_id'],
        @config['shopify']['collection_type'].to_sym

      # Get supplier inventory from all feeds
      inventory = Inventory.build @config['suppliers']
      inventory.fetch_all!
      inventory.compile
      @log[:inventory] = inventory.to_h

      # Update each product/variant based on inventory
      filter = VariantFilter.new @config, inventory
      filter.filter_variants( variants ).each do |variant|
        quantity = inventory[variant.sku]
        variant.update_drop_ship_availability! (quantity > 0)
        sleep @seconds_between_calls if variant.updated?
      end

      @log[:variants] = variants.map(&:to_h)
      puts @config['success_message'] if @config['success_message']
    rescue Exception => e
      puts "Supper encountered an error: #{e.message}"
      @log[:error] = {
        message: e.message,
        backtrace: e.backtrace
      }
    ensure
      summarize_and_log_run
      clear_temp_files
    end


    protected

    def summarize_and_log_run
      if @log[:variants]
        summary = {
          total_variants: @log[:variants].count,
          variants_updated: 0,
          variants_updated_to_unavailable: 0,
          variants_updated_to_available: 0
        }

        @log[:variants].each do |v|
          if v[:updated]
            summary[:variants_updated] += 1

            if v[:current_policy] == Variant::POLICY_DROP_SHIP_AVAILABLE
              summary[:variants_updated_to_available] += 1
            else
              summary[:variants_updated_to_unavailable] += 1
            end
          end
        end

        @log[:summary] = summary
      end

      write_log_file
    end

    def write_log_file
      f = File.open File.join(log_dir, @log[:time]+'.json'), 'w'
      f.write @log.to_json
      f.close
    end

    def clear_temp_files
      get_all_temp_files.each do |file|
        File.delete file
      end
    end

    def get_all_temp_files
      Dir.glob SupplierFeed::PREFIX+'*'
    end
  end
end
