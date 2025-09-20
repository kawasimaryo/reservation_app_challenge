class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # サインアップ
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])

    # アカウント更新（プロフィール編集用）
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :introduction])
    # もし「画像を削除する」チェックボックス等を実装していたら ↓ も追加
    # devise_parameter_sanitizer.permit(:account_update, keys: [:remove_avatar])
  end
end

