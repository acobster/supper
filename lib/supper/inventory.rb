require 'supper/supplier_feed'

module Supper
  class Inventory
    def self.build supplier_info
      inventory = Inventory.new
      supplier_info.each do |supplier|
        inventory.add_feed SupplierFeed.build(supplier)
      end
      inventory
    end

    def initialize hash={}
      @feeds = []
      @compiled = hash
    end

    def fetch_all!
      @feeds.each { |f| f.copy_inventory_file! }
    end

    def compile
      @feeds.inject({}) do |compiled, feed|
        feed.read.each do |sku, quantity|
          self[sku] = self[sku] + quantity
        end
      end
    end

    def add_feed feed
      @feeds << feed
    end

    def [] sku
      @compiled[sku].to_i
    end


    protected

    def []= sku, quantity
      @compiled[sku] = quantity
    end
  end
end
