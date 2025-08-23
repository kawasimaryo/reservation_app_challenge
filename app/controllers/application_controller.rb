class ApplicationController < ActionController::Base
  # Deviseの追加パラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録のときに :name と :avatar を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])

    # アカウント更新のときも同様に許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
