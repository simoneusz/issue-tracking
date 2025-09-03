# frozen_string_literal: true

source 'https://rubygems.org'

gem 'cssbundling-rails'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.6'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0', '>= 8.0.2.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
# gem "redis", ">= 4.0.1"
# gem "bcrypt", "~> 3.1.7"

gem 'bootsnap', require: false
gem 'devise'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rubocop-erb', '~> 0.5.5', require: false
  gem 'rubocop-factory_bot', '~> 2.27', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
end
