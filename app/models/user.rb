class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets, dependent: :destroy
  has_many :bookings
  has_many :reviews
  has_one_attached :avatar

  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { minimum: 2 }
  validates :email, format: { with: /\A(\S+)@(([a-z]{3,})\.([a-z]{2,}))\z/ }
end
