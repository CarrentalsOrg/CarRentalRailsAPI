class ApplicationController < ActionController::API
    before_action :check_json_request
    before_action :authenticate_user!

    rescue_from Exceptions::PermissionDenied, with: :forbidden_handler

    protected

      def check_json_request
        return if !request_with_body? || request.content_type&.include?("json")
        render json: { error: I18n.t("api.errors.invalid_content_type") }, status: :not_acceptable
      end

      def forbidden_handler(e)
        render json: { error: e.message }, status: :forbidden
      end

    private

    def request_with_body?
      request.post? || request.put? || request.patch?
    end
end
