# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hscode_subheading do
    category { SecureRandom.hex(3) }
    description { Faker::Lorem.sentence }
    association :hscode_heading
  end
end
