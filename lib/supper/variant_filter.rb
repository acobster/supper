module Supper
  class VariantFilter
    attr_reader :exclude_tags

    def initialize config, inventory
      exclusions = config['shopify']['exclusions']
      if exclusions and exclusions['tag']
        @exclude_tags = exclusions['tag']
      end

      @inventory = inventory
    end

    def filter_variants variants
      variants.reject do |variant|
        exclude_by_tag?( variant )
      end.reject do |variant|
        variant.sku.empty?
      end.reject do |variant|
        quantity = @inventory[variant.sku]
        quantity.nil?
      end
    end

    def exclude_by_tag? variant
      @exclude_tags.any? do |tag|
        variant.tagged_with? tag
      end
    end
  end
end
