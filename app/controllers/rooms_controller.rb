class RoomsController < ApplicationController
  # ログインしていないユーザーをログインページに飛ばす
  before_action :authenticate_user!

  def index
    # ↓↓↓ この行を書き換える ↓↓↓
    @rooms = Room.where(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    # ログインしているユーザーのIDを、施設のuser_idに保存する
    @room.user_id = current_user.id
    if @room.save
      redirect_to rooms_path, notice: '施設を登録しました。'
    else
      render :new
    end
  end

  private

  def room_params
    # 施設登録で許可するパラメータ
    params.require(:room).permit(:name, :description, :price, :address)
  end
end