require 'supper/supplier_feed'

module Supper
  class TxtFeed < SupplierFeed
    EXTENSION = '.txt'

    def read
      {}
    end
  end
end