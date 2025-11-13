# frozen_string_literal: true

class Api::V1::Auth::SessionsController < Devise::SessionsController
  include ApiConcerns

  private

  def respond_with(current_user, _opts = {})
    render json: {
      message: "You are logged in",
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]

    }, status: :ok

    def respond_to_on_destroy
      if request.headers["Authorization"].present?
        jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload["sub"])
      end
      logout_success && return if current_user
      log_out_failure
    end

    def logout_success
      render json: { message: "You are logged out" }, status: :ok
    end

    def log_out_failure
      render json: { message: "Logout failed" }, status: :unauthorized
    end
  end
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
