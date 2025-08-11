# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  # --- ここから下を追加 ---

  # プロフィール編集画面を表示するアクション
  def profile_edit
    @user = User.find(params[:id])
  end

  # プロフィール更新処理を行うアクション
  def profile_update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to reservations_path, notice: 'プロフィールを更新しました。'
    else
      render :profile_edit
    end
  end

  private

  # Strong Parameters（更新を許可する項目）
  def user_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end