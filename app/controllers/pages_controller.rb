class PagesController < ApplicationController
  def home
    if params.key?(:query)
      @pets = Pet.where("lower(name) LIKE '#{query.downcase}' OR lower(category) LIKE '#{query.downcase}'")
    else
      @pets = Pet.all
    end
  end
end
