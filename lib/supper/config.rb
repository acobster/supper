require 'yaml'
require 'recursive-open-struct'

module Supper
  class Config
    def initialize filename='config.yml'
      path = File.exists?(filename) ?
        filename :
        File.join( Dir.pwd, filename )
      @config = RecursiveOpenStruct.new( YAML.load(File.read(path)) )
    end

    def method_missing meth, *args
      @config.send meth, *args
    end
  end
end