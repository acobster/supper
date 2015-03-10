require 'net/ftp'
require 'tempfile'

module Supper
  class SupplierFeed
    SUPPORTED_FORMATS = [:txt, :csv]
    EXTENSION = ''
    PREFIX = 'tmp/'
    DEFAULT_PORT = 21

    attr_accessor :ftp_host
    attr_accessor :ftp_port
    attr_accessor :ftp_user
    attr_accessor :ftp_password
    attr_accessor :remote_file
    attr_accessor :sku_field
    attr_accessor :quantity_field

    def self.build info
      klass = class_to_build( info.inventory_format )
      return nil unless klass
      klass.new.configure info
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

    def configure info
      self.ftp_host = info.ftp_host
      self.ftp_port = info.ftp_port || DEFAULT_PORT
      self.ftp_user = info.ftp_user
      self.ftp_password = info.ftp_password
      self.remote_file = info.remote_file
      self.sku_field = info.sku_field
      self.quantity_field = info.quantity_field
      self
    end

    def copy_inventory_file! ftp=Net::FTP.new
      ftp.connect ftp_host, ftp_port
      ftp.passive = true
      ftp.login ftp_user, ftp_password
      ftp.gettextfile remote_file, @local_file
    end
  end
end
