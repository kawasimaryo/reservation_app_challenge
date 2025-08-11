Rails.application.routes.draw do
  devise_for :users
  # この行を追加してトップページを設定
  root to: 'reservations#index'

  # deviseのルーティング（後でdeviseコマンドが自動で追加してくれる）

  resources :users
  resources :rooms
  resources :reservations
end