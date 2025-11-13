class ApplicationController < ActionController::API
    include ApiConcerns

    before_action :authenticate_user!
end
