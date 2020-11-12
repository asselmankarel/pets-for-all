class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.where(user: current_user)
    find_incomming_bookings
    @bookings = Booking.where(user: current_user)
  end

  private

  def find_incomming_bookings
    all_bookings = Booking.where("end_date >= '#{DateTime.now}'")
    @incomming_bookings = []
    all_bookings.each do |booking|
      @incomming_bookings << booking if booking.pet.user == current_user
    end
  end
end
