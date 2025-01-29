class Api::V1::RentalsController < ApplicationController
  before_action :set_rental, only: %i[ show update destroy ]

    # GET /rentals/1
    def show
      render json: @rental
    end

    # POST /rentals
    def create
      @rental = Rental.create(rental_create_params)

      if @rental.save && @rental.blocked_date.save
        render json: @rental, include: [ :blocked_date ], status: :created
      else
        render json: @rental.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /rentals/1
    def update
      if @rental.update(rental_params)
        render json: @rental
      else
        render json: @rental.errors, status: :unprocessable_entity
      end
    end

    # DELETE /rentals/1
    def destroy
      @rental.destroy!
    end

    private
    def set_rental
      @rental = Rental.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rental_params
      params.require(:rental).permit(:vehicle_id, blocked_date_attributes: [ :start_date, :finish_date ])
    end

    def rental_create_params
      rental_params.merge!({ "user_id" => current_user.id })
    end
end
