# frozen_string_literal: true

# Order serializer
class OrderSerializer
  include JSONAPI::Serializer

  attributes :total_price, :status
  belongs_to :user
  has_many :order_items
end
