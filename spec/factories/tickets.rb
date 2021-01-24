FactoryBot.define do
  factory :ticket do
    name { Faker::Lorem.word }
    association :ticket_type
  end
end
