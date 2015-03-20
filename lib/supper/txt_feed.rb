require 'supper/supplier_feed'

module Supper
  class TxtFeed < SupplierFeed
    EXTENSION = '.txt'

    attr_accessor :delim

    def configure info
      super info
      self.delim = info['delim']
      self
    end

    def read
      raw = File.read @local_file
      inventory = {}

      raw.lines.each do |line|
        # TODO detect invalid UTF-8 instead...
        begin
          product = line.split delim
          sku = product[sku_field]
          # strip non-digits and convert quantity to an int
          quantity = product[quantity_field].gsub(/\D+/, '').to_i
          inventory[sku] = quantity
        rescue Exception => e
          next
        end
      end

      inventory
    end
  end
end