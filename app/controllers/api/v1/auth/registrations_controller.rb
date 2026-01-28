# frozen_string_literal: true

class Api::V1::Auth::RegistrationsController < Devise::RegistrationsController
  private
  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
      status: { code: 200, message: "Signed up successfully." },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def register_failed
    render json: {
      status: { code: 422, message: "User couldn't be created successfully. #{current_user&.errors&.full_messages&.to_sentence}" }
    }, status: :unprocessable_entity
  end
end
