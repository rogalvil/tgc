# frozen_string_literal: true

# Order serializer
class OrderSerializer
  include JSONAPI::Serializer

  attributes :id, :total_price, :status, :created_at, :updated_at
  belongs_to :user
  has_many :order_items
end
