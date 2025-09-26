class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile_edit, :profile_update, :account]
  before_action :authorize_user!, only: [:profile_edit, :profile_update, :account]

  def index
    @users = User.all
  end

  # プロフィール編集
  def profile_edit; end

  def profile_update
    if @user.update(user_profile_params)
      redirect_to reservations_path, notice: 'プロフィールを更新しました。'
    else
      render :profile_edit
    end
  end

  # アカウントページ（メール表示、パスワードは*******）
  def account; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: '権限がありません。' unless @user == current_user
  end

  # Strong Params（avatar を許可。:image ではなく :avatar）
  def user_profile_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end
end
