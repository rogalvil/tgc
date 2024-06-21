# frozen_string_literal: true

# Product serializer
class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :sku, :name, :description, :price, :stock, :status
end
