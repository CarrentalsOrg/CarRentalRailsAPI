class Api::V1::HealthCheckController < ApplicationController
  rescue_from(Exception) { render head: 503 }
  skip_before_action :authenticate_user!
  def show
    render head: 200
  end
end
