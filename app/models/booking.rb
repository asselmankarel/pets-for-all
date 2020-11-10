class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates :start_date, :end_date, presence: true
  validate :date_validation

  private

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
