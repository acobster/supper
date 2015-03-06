module Supper
  class Inventory
    def self.build supplier_info
      inventory = ::Supper::Inventory.new
      supplier_info.each do |supplier|
        feed = SupplierFeed.build supplier
        inventory.add_feed feed
      end
    end

    def initialize
      @feeds = []
    end

    def add_feed feed
      @feeds << feed
    end
  end
end