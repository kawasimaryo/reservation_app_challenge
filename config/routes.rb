Rails.application.routes.draw do
  devise_for :users
  root to: 'reservations#index'

  resources :users do
    member do
      get 'profile_edit'
      patch 'profile_update'
    end
  end
  
  # ↓↓↓ この部分を書き換える ↓↓↓
  resources :rooms do
    collection do
      get 'search'
    end
  end

  resources :reservations
end