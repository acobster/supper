require 'net/ftp'
require 'tempfile'

module Supper
  class SupplierFeed
    SUPPORTED_FORMATS = [:txt, :csv]
    EXTENSION = ''
    PREFIX = 'tmp/'

    attr_accessor :ftp_host
    attr_accessor :ftp_user
    attr_accessor :ftp_password
    attr_accessor :remote_file
    attr_accessor :sku_field
    attr_accessor :quantity_field

    def self.build info
      klass = class_to_build( info.inventory_format )
      return nil unless klass
      feed = klass.new

      feed.ftp_host = info.ftp_host
      feed.ftp_user = info.ftp_user
      feed.ftp_password = info.ftp_password
      feed.remote_file = info.remote_file
      feed.sku_field = info.sku_field
      feed.quantity_field = info.quantity_field

      feed
    end

    def self.class_to_build format
      unless SUPPORTED_FORMATS.include? format.to_sym
        raise "Unsupported format: #{format}"
      end

      # e.g. TxtFeed
      Supper.const_get format.to_s.capitalize+'Feed'
    end

    def initialize
      @local_file = Dir::Tmpname.make_tmpname PREFIX, EXTENSION
    end

    def copy_inventory_file ftp
      ftp.connect @host
      ftp.passive = true
      ftp.login @user, @pass
      ftp.gettextfile @remote_file, @local_file
    end
  end
end
