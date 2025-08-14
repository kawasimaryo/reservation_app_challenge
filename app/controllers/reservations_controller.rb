class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # ログイン中のユーザーが予約したものだけを表示する
    @reservations = current_user.reservations.includes(:room)
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user

    if @reservation.save
      redirect_to @room, notice: '施設を予約しました。'
    else
      render 'rooms/show', status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :people_count)
  end
end
