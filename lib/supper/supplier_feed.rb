require 'net/ftp'

module Supper
  class SupplierFeed
    SUPPORTED_FORMATS = [:txt, :csv]

    def self.build info
      klass = class_to_build( info.inventory_format )
      return nil unless klass
      klass.new info.ftp_user, info.ftp_password, info.ftp_inventory_file
    end

    def self.class_to_build format
      unless SUPPORTED_FORMATS.include? format.to_sym
        raise "Unsupported format: #{format}"
      end

      # e.g. TxtFeed
      Supper.const_get format.to_s.capitalize+'Feed'
    end

    def initialize ftp_user, ftp_pass, inventory_file, passive_mode=true
      @ftp_user = ftp_user
      @ftp_pass = ftp_pass
      @inventory_file = inventory_file
      @passive_mode = passive_mode
    end
  end
end