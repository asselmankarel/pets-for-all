class ReviewsController < ApplicationController
  def create
    @pet = Pet.find(params[:pet_id])
    @user = current_user
    @review = Review.new(review_params)
    @review.user = @user
    @review.pet = @pet
    @booking = Booking.new
    @available_dates = set_dates
    if @review.save
      redirect_to pet_path(@pet)
    else
      render 'pets/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
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
