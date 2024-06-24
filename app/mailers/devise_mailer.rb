# frozen_string_literal: true

# Devise Mailer
class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, options = {})
    options[:subject] = 'Reset password instructions'
    @token = token
    devise_mail(record, :reset_password_instructions, options)
  end
end
