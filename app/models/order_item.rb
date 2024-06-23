# frozen_string_literal: true

# OrderItem model
class OrderItem < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :order, inverse_of: :order_items
  belongs_to :product, inverse_of: :order_items

  before_validation :set_price, on: %i[create update]
  after_save :update_order_total
  after_destroy :update_order_total

  private

  def set_price
    self.price = product.price
  end

  def update_order_total
    order.update_total_price
  end
end
