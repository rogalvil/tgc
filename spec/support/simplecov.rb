require 'simplecov'

SimpleCov.start 'rails' do
  add_filter [/spec/, /config/]
end
