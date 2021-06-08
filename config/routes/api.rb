namespace :api, defaults: { format: :json } do
  resources :users, path: 'users', only: [:create]
  resources :cabs, path: 'cabs', only: [:update]
  resources :cab_bookings, path: 'cab-bookings', only: [:create, :update, :index]
end
