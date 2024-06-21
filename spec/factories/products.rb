FactoryBot.define do
  factory :product do
    sequence(:sku) { |n| "SKU#{n}" }
    sequence(:name) { |n| "Product Name #{n}" }
    description { 'Description of the product' }
    price { 10.0 }
    stock { 100 }
    status { 'inactive' }

    trait :active do
      status { 'active' }
    end

    trait :discontinued do
      status { 'discontinued' }
    end

    trait :preorder do
      status { 'preorder' }
    end

    trait :out_of_stock do
      stock { 0 }
    end
  end
end
