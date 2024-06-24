# frozen_string_literal: true

# Product model
class Product < ApplicationRecord
  validates :sku, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[active inactive discontinued preorder] }

  enum status: { active: 'active', inactive: 'inactive',
                 discontinued: 'discontinued', preorder: 'preorder' }

  scope :search, ->(query) { where('name ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%") }

  has_many :order_items, dependent: :destroy, inverse_of: :product

  before_save :normalize_sku

  private

  def normalize_sku
    self.sku = sku.upcase
  end
end
