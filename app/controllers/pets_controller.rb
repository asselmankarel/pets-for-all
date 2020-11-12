require 'date'

class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = params.key?(:category) ? Pet.where(category: params[:category]) : Pet.all

    @markers = @pets.geocoded.map do |pet|
      {
        lat: pet.latitude,
        lng: pet.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { pet: pet }),
        image_url: helpers.asset_url('paw.png')
      }
    end
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user
    if @pet.save
      redirect_to pet_path(@pet)
    else
      render :new
    end
  end

  def show
    @pet = Pet.find(params[:id])
    @available_dates = set_dates
    bookings = @pet.bookings.where("end_date >= '#{DateTime.now}' AND start_date < '#{DateTime.now.next_day(8)}'")
    bookings.each do |booking|
      @available_dates.each do |date|
        date[:available] = false if (booking.start_date..booking.end_date).cover?(date[:date])
      end
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = current_user.pets.find(params[:id])
    @pet.update(pet_params)
    redirect_to pet_path(@pet)
  end

  def destroy
    @pet = current_user.pets.find(params[:id])
    @pet.destroy
    redirect_to pets_path
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :birth_date, :category, :gender, :description, :available, :price_per_day, :address, :photo)
  end

  def set_dates
    date = DateTime.now
    date_hash = []
    7.times do
      date_hash << { date: date, available: true }
      date = date.next_day(1)
    end
    return date_hash
  end
end
