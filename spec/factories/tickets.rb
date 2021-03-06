# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    name { Faker::Lorem.word }
    association :ticket_type
    association :reservation
  end
end
