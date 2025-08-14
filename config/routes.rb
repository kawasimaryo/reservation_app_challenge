Rails.application.routes.draw do
  devise_for :users
  root to: 'reservations#index'

  resources :users do
    member do
      get 'profile_edit'
      patch 'profile_update'
    end
  end
  
  resources :rooms do
    # ↓↓↓ この行を追加する ↓↓↓
    resources :reservations, only: [:create]

    collection do
      get 'search'
    end
  end

  # resources :reservations # ← この行は削除する
end