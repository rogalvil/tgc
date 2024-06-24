# frozen_string_literal: true

# Order model
class Order < ApplicationRecord
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }

  belongs_to :user, inverse_of: :orders
  has_many :order_items, dependent: :destroy, inverse_of: :order

  enum status: { pending: 'pending', paid: 'paid', shipped: 'shipped',
                 delivered: 'delivered', cancelled: 'cancelled' }

  def update_total_price
    self.total_price = order_items.sum { |order_item| order_item.quantity * order_item.price }
    save
  end
end
