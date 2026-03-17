require "rails_helper"

RSpec.describe Rental, type: :model do
  fixtures :users, :vehicles, :rentals, :blocked_dates

  context "#rental should be correctly validated" do
      subject { described_class.new(canceled: false,
                                    blocked_date_attributes: {
                                                                start_date: Date.today + 3.days,
                                                                finish_date: Date.today + 5.days }) } # Overlaping with upcoming_valid_rental dates
      it "Rental with valid attributes should be valid" do
        valid_rental = rentals(:upcoming_valid_rental)
        expect(valid_rental.valid?).to be true
        expect(valid_rental.errors.full_messages.empty?).to be true
      end

      it "should have a vehicle" do
        expect(subject.valid?).to be false
        expect(subject.errors[:vehicle].empty?).to be false
      end

      it "should have a user" do
        expect(subject.valid?).to be false
        expect(subject.errors[:user].empty?).to be false
      end

      it "blocked dates should be not available" do
        subject.vehicle = vehicles(:minimum_valid_vehicle)
        expect(subject.valid?).to be false
        expect(subject.errors[:blocked_date_availability].empty?).to be false
      end

      it "should have blocked dates" do
        subject.blocked_date = nil
        expect(subject.valid?).to be false
        expect(subject.errors[:blocked_date].empty?).to be false
      end
  end

  context "#rental state is correctly defined" do
    it "should return upcoming" do
      expect(rentals(:upcoming_valid_rental).rental_state).to equal(:upcoming)
    end
    it "should return ongoing" do
      expect(rentals(:ongoing_valid_rental).rental_state).to equal(:ongoing)
    end
    it "should return concluded" do
      expect(rentals(:concluded_valid_rental).rental_state).to equal(:concluded)
    end
    it "should return canceled" do
      expect(rentals(:canceled_valid_rental).rental_state).to equal(:canceled)
    end
  end

  context "#rental update" do
    it "should ongoing rental should not be cancelable" do
      expect(rentals(:ongoing_valid_rental).updateble?).to be false
    end
    it "should concluded rental should not be cancelable" do
      expect(rentals(:concluded_valid_rental).updateble?).to be false
    end
    it "should upcoming rental should be cancelable" do
      expect(rentals(:upcoming_valid_rental).updateble?).to be true
    end
  end

  it "should calculate cost correctly" do
    expect(rentals(:upcoming_valid_rental).total_rental_cost).to eq(BigDecimal("20"))
  end
end
