# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
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
    if @authenticated && current_user.nil?
      # current_user is logged out successfully
      render status: :ok
    else
      # current_user is not logged out successfully
      render status: :unprocessable_entity
    end
  end

  def respond_with(resource, _opts = {})
    p resource.inspect
    if current_user
    # if resource && resource.persisted?
      # current_user is logged in successfully
      render json: {
        # user: resource
        user: current_user.as_json(except: :jti)
      }, status: :ok
    else
      # current_user is not logged in successfully
      render json: {
        messages: ["Invalid Email or Password."],
      }, status: :unprocessable_entity
    end
  end

  # private

  # def respond_with(resource, _opt = {})
  #   @token = request.env['warden-jwt_auth.token']
  #   headers['Authorization'] = @token

  #   render json: {
  #     status: {
  #       code: 200, message: 'Logged in successfully.',
  #       token: @token,
  #       data: {
  #         user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
  #       }
  #     }
  #   }, status: :ok
  # end

  # def respond_to_on_destroy
  #   if request.headers['Authorization'].present?
  #     jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
  #                              Rails.application.credentials.devise_jwt_secret_key!).first

  #     current_user = User.find(jwt_payload['sub'])
  #   end

  #   if current_user
  #     render json: {
  #       status: 200,
  #       message: 'Logged out successfully.'
  #     }, status: :ok
  #   else
  #     render json: {
  #       status: 401,
  #       message: "Couldn't find an active session."
  #     }, status: :unauthorized
  #   end
  # end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
