FactoryBot.define do
  factory :message do
    sequence(:number) { |n| n }
    chat_id { nil }
    body { Faker::Lorem.sentence }
  end
end
