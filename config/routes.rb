Rails.application.routes.draw do
  devise_for :users
  root to: 'reservations#index'

  # ↓↓↓ この部分を書き換える ↓↓↓
  resources :users do
    member do
      get 'profile_edit'
      patch 'profile_update'
    end
  end
  
  resources :rooms
  resources :reservations
end