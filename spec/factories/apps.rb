FactoryBot.define do
  factory :app do
    name { Faker::App.name }
    chats_count { 0 }
  end
end
