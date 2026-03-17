class Api::V1::VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show update destroy ]
  before_action :check_user, only: %i[ update destroy ]

  # GET /vehicles
  def index
    @vehicles = Vehicle.get_vehicles(vehicle_index_params)
    render json: @vehicles
  end

  # GET /vehicles/1
  def show
    render json: @vehicle
  end

  # POST /vehicles
  def create
    @vehicle = Vehicle.new(create_params)

    if @vehicle.save
      render json: @vehicle, status: :created
    else
      render json: @vehicle.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vehicles/1
  def update
    if @vehicle.update(vehicle_params)
      render json: @vehicle
    else
      render json: @vehicle.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vehicles/1
  def destroy
     if @vehicle.destroy
      head :no_content
     else
      render json: @vehicle.errors, status: :unprocessable_entity
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def check_user
      if !@vehicle.nil? && @vehicle.user.id != current_user.id
          raise Exceptions::PermissionDenied.new("You are not the owner of the vehicle")
      end
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.require(:vehicle).permit(:brand, :model, :category, :transmission, :vehicle_type, :cost, :capacity)
    end

    def vehicle_index_params
      params.permit(:vehicle).permit(:brand, :model, :category, :transmission, :vehicle_type, :bottom_cost, :upepr_cost,  :capacity)
    end

    def create_params
      vehicle_params.merge!({ "user_id" => current_user.id })
    end
end
