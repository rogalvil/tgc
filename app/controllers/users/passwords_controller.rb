# frozen_string_literal: true

# Users module
module Users
  # Override the default Devise passwords controller
  class PasswordsController < Devise::PasswordsController
    include Api::V1::PasswordsControllerDoc
    prepend_before_action :require_no_authentication
    respond_to :json

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      if successfully_sent?(resource)
        # Send just a token in the response
        render_json_messages(['Instructions have been sent to your email with the reset token'], :ok)
      else
        render_json_messages(resource.errors.full_messages.uniq, :unprocessable_entity)
      end
    end

    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      handle_password_update
    end

    private

    def handle_password_update
      if resource.errors.empty?
        unlock_resource_if_needed
        render_json_messages(['Password has been successfully changed'], :ok)
      else
        render_json_messages(resource.errors.full_messages.uniq, :unprocessable_entity)
      end
    end

    def unlock_resource_if_needed
      resource.unlock_access! if unlockable?(resource)
    end

    def resource_params
      params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
    end
  end
end
