FactoryBot.define do
  factory :comment do
    body { "MyText" }
    issue { nil }
    user { nil }
  end
end
