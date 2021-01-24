FactoryBot.define do
  factory :reservation do
    status { 0 }
    association :event
  end
end
