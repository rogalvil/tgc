# frozen_string_literal: true

# Devise module
module Devise
  # API failure application
  class ApiFailureApp < Devise::FailureApp
    def respond
      self.status        = 401
      self.content_type  = 'application/json'
      self.response_body = { errors: [{ status: '401', title: i18n_message }] }.to_json
    end
  end
end
