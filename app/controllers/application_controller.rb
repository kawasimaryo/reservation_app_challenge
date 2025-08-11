class ApplicationController < ActionController::Base
  # ↓↓↓ この3行を追加する ↓↓↓
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # :sign_up（新規登録）の時に、:name というキーのパラメータを許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end