FactoryBot.define do
  factory :order do
    total_price { 100.0 }
    status { 'pending' }
    association :user
  end

  trait :paid do
    status { 'paid' }
  end

  trait :shipped do
    status { 'shipped' }
  end

  trait :delivered do
    status { 'delivered' }
  end

  trait :cancelled do
    status { 'cancelled' }
  end
end
