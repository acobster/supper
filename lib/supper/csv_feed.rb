require 'supper/supplier_feed'

module Supper
  class CsvFeed < SupplierFeed
    EXTENSION = '.csv'

    def read
      {}
    end
  end
end