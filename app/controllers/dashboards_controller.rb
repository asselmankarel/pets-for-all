class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.where(user: current_user)
  end
end
