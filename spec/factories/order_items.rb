FactoryBot.define do
  factory :order_item do
    quantity { 2 }
    price { 20.0 }
    association :order
    association :product
  end
end
