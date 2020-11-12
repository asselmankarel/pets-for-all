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
end
