# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    status { %w(warning stop recall ).sample }
    info { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    association :commodity

    factory :invalid_state do
      status "wrong status"
    end
  end
end
