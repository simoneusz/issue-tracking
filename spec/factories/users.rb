# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email {  Faker::Internet.unique.email }
    password { '123456' }
    password_confirmation { '123456' }
    name { Faker::Internet.unique.user_name(specifier: 3..20) }
  end
end
