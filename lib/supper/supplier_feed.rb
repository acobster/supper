require 'net/ftp'
require 'tempfile'

module Supper
  class SupplierFeed
    SUPPORTED_FORMATS = [:txt, :csv]
    EXTENSION = ''
    PREFIX = 'tmp/'

    def self.build info
      klass = class_to_build( info.inventory_format )
      return nil unless klass
      klass.new info.ftp_host,
        info.ftp_user,
        info.ftp_password,
        info.ftp_inventory_file
    end

    def self.class_to_build format
      unless SUPPORTED_FORMATS.include? format.to_sym
        raise "Unsupported format: #{format}"
      end

      # e.g. TxtFeed
      Supper.const_get format.to_s.capitalize+'Feed'
    end

    def initialize host, user, pass, remote_file
      @host = host
      @user = user
      @pass = pass
      @remote_file = remote_file
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