class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  def new
    @room = Room.find(params[:room_id])
    # 一時的な予約オブジェクトを作成してバリデーションを実行
    @reservation = @room.reservations.build(
      start_date: params[:start_date],
      end_date: params[:end_date],
      people_count: params[:people_count],
      user: current_user
    )

    # バリデーションが成功すれば確認ページへ、失敗すれば施設詳細へ戻る
    if @reservation.valid?
      render :new
    else
      flash[:alert] = @reservation.errors.full_messages.join("、")
      redirect_to @room
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user

    if @reservation.save
      # ↓↓↓ この行を修正する ↓↓↓
      redirect_to root_path, notice: '施設を予約しました。'
    else
      # 予約確定に失敗した場合は、確認ページを再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :people_count)
  end
end