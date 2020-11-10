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
      redirect_to pet_booking @pet, @booking
    else
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to pet_booking @booking
    else
      render :edit
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy if @booking.user == current_user
    redirect_to pet_bookings
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :user_id, :pet_id)
  end
end
