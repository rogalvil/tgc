# frozen_string_literal: true

# Application controller is the parent class of all controllers in Rails.
class ApplicationController < ActionController::API
  include ActionPolicy::Controller
  authorize :user, through: :current_user

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionPolicy::Unauthorized do |ex|
    error_message = ex.policy::ERROR_MESSAGES[ex.rule.to_sym] ||
                    'You not allowed to perform this action'
    render json: { message: error_message }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { message: 'Record not found' }, status: :not_found
  end

  rescue_from ActionController::RoutingError, with: :render_not_found

  def route_not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def render_not_found
    render json: { messages: ['The requested route was not found'] }, status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
