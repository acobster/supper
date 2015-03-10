require 'supper/supplier_feed'

module Supper
  class TxtFeed < SupplierFeed
    EXTENSION = '.txt'

    attr_accessor :delim

    def configure info
      super info
      self.delim = info.delim
      self
    end

    def read
      raw = File.read @local_file
      inventory = {}

      raw.lines.each do |line|
        fields = line.split delim
        sku = line[sku_field]
        quantity = line[quantity_field]
        inventory[sku] = quantity
      end

      inventory
    end
  end
end