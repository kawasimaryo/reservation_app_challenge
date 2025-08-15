class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:search]
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @rooms = current_user.rooms
  end

  def show
    @reservation = Reservation.new
  end

  def search
    @results = Room.all
    @results = @results.where("address LIKE ?", "%#{params[:area]}%") if params[:area].present?
    @results = @results.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") if params[:keyword].present?
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: '施設を登録しました。'
    else
      render :new
    end
  end

  # --- ここから下が追加・修正部分 ---

  def edit
    # @roomはbefore_actionで設定済み
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: '施設情報を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: '施設を削除しました。'
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_user
    redirect_to root_path, alert: '権限がありません。' unless @room.user == current_user
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end