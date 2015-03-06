module Supper
  autoload :Base, File.join( Dir.pwd, 'lib/supper/base.rb' )
  autoload :Collection, File.join( Dir.pwd, 'lib/supper/collection.rb' )
  autoload :Config, File.join( Dir.pwd, 'lib/supper/config.rb' )
  autoload :Inventory, File.join( Dir.pwd, 'lib/supper/inventory.rb' )
  autoload :SupplierFeed, File.join( Dir.pwd, 'lib/supper/supplier_feed.rb' )
  autoload :Variant, File.join( Dir.pwd, 'lib/supper/variant.rb' )
end
