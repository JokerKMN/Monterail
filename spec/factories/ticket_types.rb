FactoryBot.define do
  factory :ticket_type do
    name { Faker::Lorem.word }
    selling_option { 0 }
    price { Faker::Number.number }
    quantity_total { Faker::Number.number(1) }
    association :event
  end
end
