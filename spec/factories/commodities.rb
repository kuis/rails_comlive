# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity do
    short_description { Faker::Lorem.sentence }
    long_description { Faker::Lorem.paragraph }
    measured_in { Faker::Lorem.word }
    association :app
    association :brand

    factory :invalid_commodity do
      short_description nil
    end

    factory :generic_commodity do
      generic true
    end

    factory :non_generic_commodity do
      generic false
    end
  end
end
