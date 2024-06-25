# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '7.1.3.4'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]

  # FactoryBot integration between FactoryBot and Rails
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

  # RSpec is a testing tool for Ruby, created for behavior-driven development (BDD)
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'

  # JSON API testing suite for RSpec
  gem 'jsonapi-rspec'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
  gem 'rubocop', '~> 1.64', '>= 1.64.1', require: false

  # IDE tools for code completion, inline documentation, and static analysis
  gem 'solargraph', '~> 0.50.0', require: false
end

group :test do
  # Webmock is a library for stubbing http request (with Faraday in the case)
  gem 'webmock', '~> 3.23', '>= 3.23.1'

  # Provides RSpec- and Minitest-compatible one-liners to test common Rails
  # functionality that, if written by hand, would be much longer, more complex,
  # and error-prone.
  gem 'shoulda-matchers', '~> 6.2'

  # Generates test vs. code coverage reports
  gem 'simplecov', '~> 0.22.0', require: false
end

# Flexible authentication solution for Rails based on Warden
gem 'devise', '~> 4.9', '>= 4.9.4'

# Devise extension that uses JWT tokens for user authentication
gem 'devise-jwt', '~> 0.11.0'

# Authorization framework for Rails applications
gem 'action_policy', '~> 0.6.9'

# Fast JSON parser and Object marshaller as a Ruby gem
gem 'oj'

# JSON APIs using object serialization
gem 'jsonapi-serializer'

# Rails REST API documentation tool
gem 'apipie-rails'

# Fix ambiguous gems on container
gem 'drb', '2.2.0'
gem 'minitest', '5.20.0'
