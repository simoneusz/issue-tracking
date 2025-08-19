FactoryBot.define do
  factory :issue do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    project { nil }
    user { nil }
  end
end
