FactoryBot.define do
  factory :guest do
    initialize_with { Guest.new }
  end
end
