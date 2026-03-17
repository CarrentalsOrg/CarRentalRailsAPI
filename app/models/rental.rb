class Rental < ApplicationRecord
  belongs_to :vehicle
  belongs_to :user
  has_one :blocked_date
  accepts_nested_attributes_for :blocked_date, allow_destroy: true

  STATES = %i[canceled concluded ongoing upcoming]

  # VALIDATIONS
  # create
  validates_presence_of :blocked_date, :user_id, :vehicle_id
  # create & update
  validate :dates_available, on: [ :create, :update ], if: :should_validate_dates?
  validate :validates_update, on: :update

  # CALLBACKS
  before_update :validates_update


  # RECORD METHODS
  def total_rental_cost
    self.vehicle.cost * (self.blocked_date.finish_date - self.blocked_date.start_date)
  end

  def rental_state
    if self.canceled
      STATES[0]
    elsif Date.today > self.blocked_date.finish_date
      STATES[1]
    elsif Date.today.between?(self.blocked_date.start_date,  self.blocked_date.finish_date)
      STATES[2]
    else
      STATES[3]
    end
  end

  def updateble?
   Date.today < self.blocked_date.start_date
  end

  private

  # VALIDATION METHODS

  def should_validate_dates?
    self.canceled == false && self.vehicle.present?
  end

  def validates_update
    errors.add(:rental_state_error, "#{rental_state()} rental cannot be updated") unless updateble?
  end

  # Checks if passed blocked_dates overlap with vehicle's active_blocked_dates
  def dates_available
    vehicle_blocked_dates = self.vehicle.blocked_dates.reject { |b| b.id == self.blocked_date.id }
    vehicle_blocked_dates.each do |vehicle_blocked_date|
      if self.blocked_date.start_date <= vehicle_blocked_date.finish_date && vehicle_blocked_date.start_date <= self.blocked_date.finish_date
        errors.add(:blocked_date_availability, "Vehicle is not available for rent at the inserted dates!")
        break
      end
    end
  end
end
