# frozen_string_literal: true

# spec/support/api_helpers.rb
module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def login_with_api(params = {})
    post '/api/v1/login', params: {
      user: {
        email: params[:email],
        password: params[:password]
      }
    }
    response.headers['Authorization'] if response.headers['Authorization'].present?
  end

  def logout_with_api(headers = {})
    delete '/api/v1/logout', headers: {}.merge(headers)
  end
end
