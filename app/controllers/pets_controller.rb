class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user
    if @pet.save!
      redirect_to pet_path(@pet)
    else
      render :new
    end
  end

  def show
    @pet = Pet.find(params[:id])
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
    @pet.destroy!
    redirect_to pets_path
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :birth_date, :category, :gender, :description, :available, :price_per_day, :address)
  end
end
