class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :rentals
  has_many :active_rentals, -> { where(canceled: false) }, class_name: "Rental"
  has_many :blocked_dates, through: :active_rentals, class_name: "BlockedDate"

  # FILTER SCOPES
  scope :with_brand, ->(brand) { where(brand: brand) }
  scope :with_model, ->(model) { where(model: model) }
  scope :with_category, ->(category) { where(category: category) }
  scope :with_transmission, ->(transmission) { where(transmission: transmission) }
  scope :with_vehicle_type, ->(vehicle_type) { where(vehicle_type: vehicle_type) }
  scope :with_capacity, ->(capacity) { where(capacity: capacity) }
  scope :with_cost_between, ->(botttom_cost, upper_cost) { where(cost: botttom_cost..upper_cost) }

  enum category: [ :small, :medium, :big, :suv, :truck ]
  enum transmission: [ :manual, :auto ]
  enum vehicle_type: [ :car, :motorcycle, :ev, :evcycle ]
  enum capacity: [ "1-4", "5-6", "7 plus" ].freeze

  # VALIDATIONS
  validates_presence_of :brand, :model, :cost, :user
  validates :brand, :model, length: { maximum: 15 }

  # CALLBACKS
  before_destroy :vehicle_can_be_destroyed?, prepend: true

  def self.get_vehicles(params)
    return Vehicle.all if params.empty?
    filter(params)
  end

  def self.filter(params)
    vehicles = []
    vehicles = vehicles.with_category(params[:category]) if params[:category].present?
    vehicles = vehicles.with_transmission(params[:transmission]) if params[:transmission].present?
    vehicles = vehicles.with_vehicle_type(params[:vehicle_type]) if params[:vehicle_type].present?
    vehicles = vehicles.with_capacity(params[:capacity]) if params[:capacity].present?
    vehicles = vehicles.with_cost_between(params[:bottom_cost], params[:upper_cost]) if params[:bottom_cost].present? && params[:upper_cost].present?
    vehicles
  end

  def vehicle_can_be_destroyed?
    if self.active_rentals.exists?
      errors.add(:vehicle, "Vehicle has active rentals!")
      throw :abort
    end
  end
end
