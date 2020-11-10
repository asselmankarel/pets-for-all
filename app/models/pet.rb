class Pet < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_one_attached :photo

  CATEGORIES = %w[Dog Cat Horse Reptile Rodent Dragon Unicorn]
  GENDERS = %w[Male Female Unknown]

  validates :name, presence: true
  validates :address, presence: true
  validates :gender, presence: true, inclusion: { in: GENDERS }
  validates :birth_date, presence: true
  validates :price_per_day, presence: true, numericality: { only_float: true, greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end
