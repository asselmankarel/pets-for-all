class Review < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates :content, :rating, presence: true
  validates :rating, inclusion: { in: 0..5 }
  validates :rating, numericality: { only_integer: true }
end
