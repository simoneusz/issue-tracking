# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "Issue #{n}" }
    description { 'A sample issue description for testing' }
    status { 'open' }
    association :project
    association :user
    association :assignee, factory: :user
  end
end
