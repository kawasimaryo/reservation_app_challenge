Rails.application.routes.draw do
  devise_for :users
  root to: 'reservations#index'

  resources :users do
    member do
      get  :profile_edit
      patch :profile_update
      get  :account        # ←これを追加
    end
  end

  resources :rooms do
    collection { get :search }
    resources :reservations, only: [:new, :create, :destroy]
  end

  resources :reservations, only: [:index]
end
