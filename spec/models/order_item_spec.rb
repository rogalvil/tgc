require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:product) { create(:product, price: 20.0) }

  it 'is valid with valid attributes' do
    order_item = build(:order_item)
    expect(order_item).to be_valid
  end

  it 'is invalid without a quantity' do
    order_item = build(:order_item, quantity: nil)
    expect(order_item).not_to be_valid
  end

  it 'is invalid with a quantity of zero' do
    order_item = build(:order_item, quantity: 0)
    expect(order_item).not_to be_valid
  end

  it 'is invalid with a negative quantity' do
    order_item = build(:order_item, quantity: -1)
    expect(order_item).not_to be_valid
  end

  it 'is valid without a price set from the product' do
    order_item = build(:order_item, price: nil)
    expect(order_item).to be_valid
    expect(order_item.price).to eq(order_item.product.price)
  end

  it 'is valid with a negative price set from the product' do
    order_item = build(:order_item, price: -10.0)
    expect(order_item).to be_valid
    expect(order_item.price).to eq(order_item.product.price)
  end

  it 'is valid without a price set from the product' do
    order_item = build(:order_item, product:)
    expect(order_item).to be_valid
    expect(order_item.price).to eq(product.price)
  end

  it 'belongs to an order' do
    order = create(:order)
    order_item = build(:order_item, order:)
    expect(order_item.order).to eq(order)
  end

  it 'belongs to a product' do
    product = create(:product)
    order_item = build(:order_item, product:)
    expect(order_item.product).to eq(product)
  end
end
