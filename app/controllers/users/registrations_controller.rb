# frozen_string_literal: true

# Users module
module Users
  # Override the default Devise registrations controller
  class RegistrationsController < Devise::RegistrationsController
    include Api::V1::RegistrationsControllerDoc
    respond_to :json

    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    private

    def respond_with(resource, _opts = {})
      if request.method == 'DELETE'
        # current_user is destroyed successfully
        render status: :ok
      elsif request.method == 'POST' && resource.persisted?
        # current_user is created successfully
        render json: { user: UserSerializer.new(current_user).serializable_hash }, status: :ok
      else
        # current_user is not created successfully
        render json: { messages: resource.errors.full_messages.uniq },
               status: :unprocessable_entity
      end
    end
  end
end
