# frozen_string_literal: true

# Application controller is the parent class of all controllers in Rails.
class ApplicationController < ActionController::API
  include ActionPolicy::Controller
  authorize :user, through: :current_user
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionPolicy::Unauthorized, with: :handle_unauthorized
  rescue_from Apipie::ParamMissing, with: :handle_param_missing
  rescue_from Apipie::ParamInvalid, with: :handle_param_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  def route_not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def current_user
    super || Guest.new
  end

  private

  def render_json_error(messages, status)
    render json: { messages: }, status:
  end

  def render_not_found
    render_json_error('The requested route was not found', :not_found)
  end

  def handle_unauthorized(exception)
    error_message = exception.policy::ERROR_MESSAGES[exception.rule.to_sym] ||
                    'You are not allowed to perform this action'
    render_json_error([error_message], :forbidden)
  end

  def handle_param_missing(exception)
    render_json_error([exception.message], :bad_request)
  end

  def handle_param_invalid(exception)
    render_json_error(["Invalid parameter #{exception.param}"], :bad_request)
  end

  def handle_record_not_found
    render_json_error(['Record not found'], :not_found)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end
end
