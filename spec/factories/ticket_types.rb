# frozen_string_literal: true

FactoryBot.define do
  factory :ticket_type do
    name { Faker::Lorem.word }
    selling_option { 0 }
    price { Faker::Number.number }
    quantity_total { Faker::Number.number(digits: 2) }
    association :event
  end
end
