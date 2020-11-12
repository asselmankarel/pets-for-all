class PagesController < ApplicationController
  def home
    @pets = Pet.last(5)
  end
end
