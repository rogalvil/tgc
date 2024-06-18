# frozen_string_literal: true

# spec/support/api_helpers.rb
module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def login_with_api(user)
    post '/api/v1/login', params: {
      user: {
        email: user.email,
        name: user.name,
        password: user.password
      }
    }
  end
end
