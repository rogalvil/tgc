require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'is valid with valid attributes' do
    order = build(:order)
    expect(order).to be_valid
  end

  it 'is invalid without a total_price' do
    order = build(:order, total_price: nil)
    expect(order).not_to be_valid
  end

  it 'is invalid with a negative total_price' do
    order = build(:order, total_price: -10.0)
    expect(order).not_to be_valid
  end

  it 'is invalid without a status' do
    order = build(:order, status: nil)
    expect(order).not_to be_valid
  end

  it 'is invalid with an invalid status' do
    order = build(:order, status: '')
    expect(order).not_to be_valid
  end

  it 'belongs to a user' do
    user = create(:user)
    order = build(:order, user:)
    expect(order.user).to eq(user)
  end

  it 'has many order_items' do
    order = create(:order)
    order_item1 = create(:order_item, order:)
    order_item2 = create(:order_item, order:)
    expect(order.order_items).to include(order_item1, order_item2)
  end
end
