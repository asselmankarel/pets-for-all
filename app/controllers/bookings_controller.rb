class BookingsController < ApplicationController
  before_action :authenticate_user!
  # new_pet_booking    GET    /pets/:pet_id/bookings/new(.:format)        bookings#new
  #                    POST   /pets/:pet_id/bookings(.:format)            bookings#create
  # edit_pet_booking   GET    /pets/:pet_id/bookings/:id/edit(.:format)   bookings#edit
  # pet_booking        GET    /pets/:pet_id/bookings/:id(.:format)        bookings#show
  #                    PATCH  /pets/:pet_id/bookings/:id(.:format)        bookings#update
  #                    DELETE /pets/:pet_id/bookings/:id(.:format)

  def index
    @bookings = Booking.where(user: current_user)
  end

  def new
    @booking = Booking.new
    @pet = Pet.find(params[:pet_id])
    @booking.pet = @pet
    @booking.user = current_user
  end

  def create
    @booking = Booking.new(booking_params)
    @pet = @booking.pet
    if @booking.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
    @pet = @booking.pet
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy if @booking.pet.user == current_user
    redirect_to dashboard_path
  end

  def booked_pets
    find_bookings
  end

  def confirm
    booking = Booking.find(params[:id])
    booking.confirmed = true if booking.pet.user == current_user
    booking.save(validate: false)
    find_bookings
    redirect_to dashboard_path
  end

  private

  def find_bookings
    all_bookings = Booking.where("end_date >= '#{DateTime.now}'")
    @bookings = []
    all_bookings.each do |booking|
      @bookings << booking if booking.pet.user == current_user
    end
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :user_id, :pet_id)
  end
end
