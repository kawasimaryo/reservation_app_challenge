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
    resources :reservations, only: [:new, :create] # 施設ごとの予約作成

    collection do
      get 'search'
    end
  end

  # ユーザーの予約一覧用トップレベルルートを追加
  resources :reservations, only: [:index]
end
