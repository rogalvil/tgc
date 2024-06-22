# frozen_string_literal: true

# OrderItem serializer
class OrderItemSerializer
  include JSONAPI::Serializer

  attributes :quantity, :price
  belongs_to :order
  belongs_to :product
end
