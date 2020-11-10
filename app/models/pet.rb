class Pet < ApplicationRecord
  belongs_to :user
  has_many :bookings

  validates :name, presence: true
  validates :address, presence: true
  validates :gender, presence: true, inclusion: { in: ["male", "female"] }
  validates :birth_date, presence: true
  validates :price_per_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :category, presence: true, inclusion: { in: %i[dog cat horse reptile rodent dragon unicorn] }
end
