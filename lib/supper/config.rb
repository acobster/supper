require 'yaml'

module Supper
  class Config
    def self.load_from_file filename='config.yml'
      yaml = File.read File.exists?(filename) ?
        filename :
        File.join( Dir.pwd, filename )

      Config.new yaml
    end

    def initialize yaml
      @config = YAML.load yaml
    end

    def method_missing meth, *args
      @config.send meth, *args
    end
  end
end