# frozen_string_literal: true

# Users module
module Users
  # Override the default Devise passwords controller
  class PasswordsController < Devise::PasswordsController
    respond_to :json

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      if successfully_sent?(resource)
        # Send just a token in the response
        render json: { message: 'Instructions have been sent to your email with the reset token.' }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        render json: { message: 'Your password has been successfully changed.' }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def resource_params
      params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
    end
  end
end
