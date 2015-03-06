require 'shopify_api'

module Supper
  class Variant
    POLICY_DROP_SHIP_AVAILABLE = 'continue'
    POLICY_DROP_SHIP_NOT_AVAILABLE = 'deny'

    attr_accessor :initial_policy
    attr_accessor :product

    def initialize variant, product
      @variant = variant
      self.product = product
      self.initial_policy = variant.inventory_policy
    end

    def update_drop_ship_availability! available
      policy = available ?
        POLICY_DROP_SHIP_AVAILABLE :
        POLICY_DROP_SHIP_NOT_AVAILABLE

      # Don't waste API calls on zero-change updates
      if policy != @variant.inventory_policy
        @variant.inventory_policy = policy
        @variant.save!
      end

      true
    end


    def method_missing name, *args
      @variant.send name, *args
    end

    def tags
      product.tags.split( /,\s*/ )
    end

    def tagged_with? tag
      tags.include? tag
    end
  end
end
