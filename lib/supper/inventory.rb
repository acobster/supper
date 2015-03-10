require 'supper/supplier_feed'

module Supper
  class Inventory
    def self.build supplier_info
      inventory = Inventory.new
      supplier_info.each do |supplier|
        feed = SupplierFeed.build supplier
        inventory.add_feed feed
      end
    end

    def initialize
      @feeds = []
    end

    def compile!
      @feeds.each do |feed|
        read_into_compiled feed
      end
    end

    def read_into_compiled feed
    end

    def add_feed feed
      @feeds << feed
    end
  end
end