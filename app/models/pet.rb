class Pet < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews
  has_many_attached :photos
  geocoded_by :address

  CATEGORIES = %w[Dog Cat Horse Reptile Rodent Dragon Unicorn]
  GENDERS = %w[Male Female Unknown]

  validates :name, presence: true
  validates :address, presence: true
  validates :gender, presence: true, inclusion: { in: GENDERS }
  validates :birth_date, presence: true
  validates :price_per_day, presence: true, numericality: { only_float: true, greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  after_validation :geocode, if: :will_save_change_to_address?

  def get_available_booking_dates(number_of_next_days)
    dates_hash = create_dates_hash(number_of_next_days)
    bookings = self.bookings.where("end_date >= '#{DateTime.now}' AND start_date <= '#{DateTime.now.next_day(number_of_next_days)}'")
    bookings.each do |booking|
      dates_hash.each do |date|
        date[:available] = false if (booking.start_date..booking.end_date + 1).cover?(date[:date])
      end
    end
    return dates_hash
  end

  def create_dates_hash(number_of_days)
    date = DateTime.now
    date_hash = []
    number_of_days.times do
      date_hash << { date: date, available: true }
      date = date.next_day(1)
    end
    return date_hash
  end
end
