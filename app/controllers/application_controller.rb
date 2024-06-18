# frozen_string_literal: true

# Application controller is the parent class of all controllers in Rails.
class ApplicationController < ActionController::API
  include ActionPolicy::Controller
  authorize :user, through: :current_user

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionPolicy::Unauthorized do |ex|
    render json: { message: "User not allowed to #{ex.rule}" }, status: :forbidden
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
