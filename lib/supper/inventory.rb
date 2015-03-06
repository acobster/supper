module Supper
  class Inventory
    def initialize filename='config.yml'
      path = File.join( Dir.pwd, filename )
      @config = RecursiveOpenStruct.new( YAML.load(File.read(path)) )
    end
  end
end