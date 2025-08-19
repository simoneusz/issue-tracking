# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { 'A sample project for testing purposes' }
    user
  end
end
