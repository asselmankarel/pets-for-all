class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates :start_date, :end_date, presence: true
  validate :date_validation

  validate :validate_other_booking_overlap

  def period
    start_date..end_date
  end

  private

  def validate_other_booking_overlap
    other_bookings = Booking.all
    is_overlapping = other_bookings.any? do |other_booking|
      period.overlaps?(other_booking.period)
    end
    errors.add(:start_date, " is alredy taken") if is_overlapping
    errors.add(:end_date, " is alredy taken") if is_overlapping
  end

  def date_validation
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end

    if start_date < Date.today
      errors.add(:start_date, "must be after today")
    end
  end
end
