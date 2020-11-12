class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.where(user: current_user)
    find_bookings
  end

  private

  def find_bookings
    all_bookings = Booking.where("end_date >= '#{DateTime.now}'")
    @bookings = []
    all_bookings.each do |booking|
      @bookings << booking if booking.pet.user == current_user
    end
  end
end
