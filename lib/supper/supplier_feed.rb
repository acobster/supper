require 'net/ftp'

module Supper
  class SupplierFeed
    FORMAT_CLASS_MAP = {
      txt: ::Supper::TxtFeed,
      csv: ::Supper::CsvFeed,
    }

    def self.build info
      klass = class_to_build( info.inventory_format )
      return nil unless klass
      klass.new info.ftp_user, info.ftp_password, info.ftp_inventory_file
    end

    def self.class_to_build format
      FORMAT_CLASS_MAP[format.to_sym]
    end

    def initialize ftp_user, ftp_pass, inventory_file, passive=true

    end

    def get_inventory

    end
  end
end