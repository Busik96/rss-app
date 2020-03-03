# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'crono'
gem 'devise'
gem 'feedjira'
gem 'haml-rails'
gem 'httparty'
gem 'jbuilder', '~> 2.7'
gem 'omniauth-facebook'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'pg'
gem 'premailer-rails'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'annotate'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot'
  gem 'faker'
  gem 'pry', git: 'https://github.com/pry/pry.git'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '4.0.0.beta3'
  gem 'rubocop'
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', '>= 0.18.5', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end
