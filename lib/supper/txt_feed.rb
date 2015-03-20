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
        begin
          line = encode_and_strip_invalid_chars line
          product = line.split delim

          sku = product[sku_field]
          # strip non-digits and convert quantity to an int
          quantity = product[quantity_field].gsub(/\D+/, '').to_i
          inventory[sku] = quantity
        rescue Exception => e
          # TODO log something here
          next
        end
      end

      inventory
    end

    def encode_and_strip_invalid_chars line
      line.encode 'UTF-8', 'binary',
        invalid: :replace, undef: :replace, replace: ''
    end
  end
end