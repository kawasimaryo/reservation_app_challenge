class RoomsController < ApplicationController
  # ログインしていないユーザーをログインページに飛ばす
  before_action :authenticate_user!, except: [:search] # searchアクションはログイン不要にする

  def index
    @rooms = Room.where(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @reservation = Reservation.new # ← この行を追加
  end

  def search
    # 検索フォームから送られてきたパラメータを取得
    @area = params[:area]
    @keyword = params[:keyword]

    # まず、全ての施設を対象にする
    @results = Room.all

    # エリア検索のパラメータがあれば、住所(address)であいまい検索
    if @area.present?
      @results = @results.where("address LIKE ?", "%#{@area}%")
    end

    # フリーワード検索のパラメータがあれば、施設名(name)と施設詳細(description)であいまい検索
    if @keyword.present?
      @results = @results.where("name LIKE ? OR description LIKE ?", "%#{@keyword}%", "%#{@keyword}%")
    end
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