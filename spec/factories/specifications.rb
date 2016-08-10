# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :specification do
    property "energy"
    value { Faker::Number.decimal(2,4) }
    uom "J"
    association :commodity

    factory :invalid_specification do
      property nil
    end
  end
end
