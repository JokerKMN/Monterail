FactoryBot.define do
  factory :event do
    name { Faker::Lorem.word }
    date { Date.tomorrow }
    time { Time.zone.now }
  end
end
