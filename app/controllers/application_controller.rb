class ApplicationController < ActionController::API
    before_action :check_json_request
    before_action :authenticate_user!

    protected

      def check_json_request
        return if !request_with_body? || request.content_type&.include?("json")
        render json: { error: I18n.t("api.errors.invalid_content_type") }, status: :not_acceptable
      end

    private

    def request_with_body?
      request.post? || request.put? || request.patch?
    end
end
