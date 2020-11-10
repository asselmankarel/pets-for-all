Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pets do
    resources :bookings, only: [:index, :new, :show, :create, :edit, :update]
  end
  # to allow a user to see all his bookings instead of going via the pet
  resources :bookings, only: [:destroy]
  get '/users/:id/bookings', to: 'bookings#index', as: 'user_bookings'
  get '/pets/find/:category', to: 'pets#index'
end
