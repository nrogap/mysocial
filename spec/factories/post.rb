FactoryBot.define do
  factory :post do
    sequence(:message) { |n| "This is message number #{n}" }
  end
end
