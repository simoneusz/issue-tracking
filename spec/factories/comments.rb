# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'This is a sample comment for testing purposes' }
    issue
    user
  end
end
