class Booking < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  belongs_to :pet

  validates :start_date, :end_date, presence: true
  validate :date_validation

  validate :validate_other_booking_overlap, on: %i[create update]

  def period
    start_date..end_date
  end

  def total_price
    number_with_precision((start_date..end_date).count * pet.price_per_day, precision: 2)
  end

  private

  def validate_other_booking_overlap
    if id
      other_bookings = Booking.where("id != ? AND pet_id = ?", id, pet_id)
    else
      other_bookings = Booking.where(pet_id: pet_id)
    end
    is_overlapping = other_bookings.any? do |other_booking|
      period.overlaps?(other_booking.period)
    end
    errors.add(:start_date, " is already taken") if is_overlapping
    errors.add(:end_date, " is already taken") if is_overlapping
  end

  def date_validation
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "must be after the start date") if end_date < start_date
    errors.add(:start_date, "must be after today") if start_date < Date.today
  end
end
