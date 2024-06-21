require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'is valid with valid attributes' do
    product = build(:product)
    expect(product).to be_valid
  end

  it 'is invalid without a sku' do
    product = build(:product, sku: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid without a name' do
    product = build(:product, name: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid without a price' do
    product = build(:product, price: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid with a negative price' do
    product = build(:product, price: -10.0)
    expect(product).not_to be_valid
  end

  it 'is invalid without a stock' do
    product = build(:product, stock: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid with a negative stock' do
    product = build(:product, stock: -1)
    expect(product).not_to be_valid
  end

  it 'is invalid without a status' do
    product = build(:product, status: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid with an invalid status' do
    product = build(:product, status: nil)
    expect(product).not_to be_valid
  end

  it 'normalizes the SKU before saving' do
    product = create(:product, sku: 'sku123')
    expect(product.sku).to eq('SKU123')
  end
end
