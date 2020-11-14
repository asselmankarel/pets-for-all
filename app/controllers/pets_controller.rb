require 'date'

class PetsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def home
    @pets = Pet.all
    put_markers

    @pets = Pet.last(4)
  end

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query OR category ILIKE :query"
      @pets = Pet.where(sql_query, query: "%#{params[:query].singularize}%")
    else
      @pets = params.key?(:category) ? Pet.where(category: params[:category]) : Pet.all
    end

    put_markers
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
    @available_dates = @pet.get_available_booking_dates(10)
    @booking = Booking.new
    @review = Review.new
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

  def put_markers
    @markers = @pets.geocoded.map do |pet|
      {
        lat: pet.latitude,
        lng: pet.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { pet: pet }),
        image_url: helpers.asset_url('paw.png')
      }
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :birth_date, :category, :gender, :description, :available, :price_per_day, :address, photos: [])
  end
end
