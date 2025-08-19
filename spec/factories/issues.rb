# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "Issue #{n}" }
    description { 'A sample issue description for testing' }
    status { 'open' }
    project
    user
    assignee factory: %i[user]
  end
end
