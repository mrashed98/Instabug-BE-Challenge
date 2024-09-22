FactoryBot.define do
  factory :chat do
    application_token { nil }
    messages_count { 0 }
    sequence(:number) { |n| n }
  end
end
