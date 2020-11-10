Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pets do
    resources :bookings
  end
  # to allow a user to see all his bookings instead of going via the pet
  get '/users/:id/bookings', to: 'bookings#index', as: 'user_bookings'
end
