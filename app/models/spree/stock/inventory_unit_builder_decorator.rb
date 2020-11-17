module Spree
  module Stock
    module InventoryUnitBuilderDecorator
      def units
        @order.line_items.flat_map do |line_item|
          line_item.quantity_by_variant.flat_map do |variant, quantity|
            build_inventory_unit(variant.id, line_item, quantity)
          end
        end
      end

      def build_inventory_unit(variant_id, line_item, quantity)
        # They go through multiple splits, avoid loading the
        # association to order until needed.
        Spree::InventoryUnit.new(
          pending: true,
          line_item_id: line_item.id,
          variant_id: variant_id,
          quantity: quantity,
          order_id: @order.id
        )
      end
    end
  end
end

Spree::Stock::InventoryUnitBuilder.prepend Spree::Stock::InventoryUnitBuilderDecorator
