# frozen_string_literal: true

# Users module
module Users
  # Override the default Devise sessions controller
  class SessionsController < Devise::SessionsController
    include Api::V1::SessionsControllerDoc
    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, {}
    end

    def destroy
      @authenticated = true
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      yield if block_given?
      respond_to_on_destroy
    end

    private

    def verify_signed_out_user
      current_user
      super
    end

    def respond_to_on_destroy
      if @authenticated && current_user.guest?
        # current_user is logged out successfully
        render_json_messages(['Logout successfully'], :ok)
      else
        # current_user is not logged out successfully
        render_json_messages(['Logout was not successful'], :unprocessable_entity)
      end
    end

    def respond_with(_resource, _opts = {})
      if current_user
        # current_user is logged in successfully
        render json: { user: UserSerializer.new(current_user).serializable_hash }, status: :ok
      else
        # current_user is not logged in successfully
        render_json_messages(['Invalid Email or Password'], :unprocessable_entity)
      end
    end
  end
end
