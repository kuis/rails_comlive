# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ownership do
    association :parent, factory: :official_brand
    association :child, factory: :brand

    factory :invalid_ownership do
      association :parent, factory: :brand
    end
  end
end
