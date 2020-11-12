class ReviewsController < ApplicationController
  def create
    @pet = Pet.find(params[:pet_id])
    @user = current_user
    @review = Review.new(review_params)
    @review.user = @user
    @review.pet = @pet
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
end
