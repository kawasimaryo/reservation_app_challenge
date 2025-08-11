Rails.application.routes.draw do
  resources :users
  resources :rooms
  resources :reservations
end
