# frozen_string_literal: true

# Users module
module Users
  # Override the default Devise sessions controller
  class SessionsController < Devise::SessionsController
    respond_to :json

    def destroy
      @authenticated = true
      super
    end

    private

    def verify_signed_out_user
      current_user
      super
    end

    def respond_to_on_destroy
      if @authenticated && current_user.guest?
        # current_user is logged out successfully
        render json: { messages: ['Logout successfully'] }, status: :ok
      else
        # current_user is not logged out successfully
        render json: { messages: ['Logout was not successful'] }, status: :unprocessable_entity
      end
    end

    def respond_with(_resource, _opts = {})
      if current_user
        # current_user is logged in successfully
        render json: { user: UserSerializer.new(current_user).serializable_hash }, status: :ok
      else
        # current_user is not logged in successfully
        render json: { messages: ['Invalid Email or Password'] },
               status: :unprocessable_entity
      end
    end
  end
end
