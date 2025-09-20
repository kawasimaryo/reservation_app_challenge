class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:new, :create, :destroy]

  def index
    @reservations = current_user.reservations
                                .includes(:room)
                                .order(start_date: :desc)
  end

  # GET /rooms/:room_id/reservations/new?start_date=...&end_date=...&people_count=...
  def new
    begin
      start_date = Date.parse(params[:start_date])
      end_date   = Date.parse(params[:end_date])
    rescue ArgumentError
      flash[:alert] = "日付の形式が正しくありません。"
      return redirect_to @room
    end
    people = params[:people_count].to_i

    @reservation = current_user.reservations.new(
      room: @room,
      start_date: start_date,
      end_date: end_date,
      people_count: people
    )

    if @reservation.valid?
      @days        = (end_date - start_date).to_i
      @total_price = (@days * @room.price.to_i * people).to_i
      render :new
    else
      flash[:alert] = @reservation.errors.full_messages.join("、")
      redirect_to @room
    end
  end

  # POST /rooms/:room_id/reservations
  def create
    @reservation = current_user.reservations.new(reservation_params.merge(room: @room))

    if @reservation.save
      redirect_to reservations_path, notice: "施設を予約しました。"
    else
      @days        = (@reservation.end_date - @reservation.start_date).to_i
      @total_price = (@days * @room.price.to_i * @reservation.people_count.to_i).to_i
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/:room_id/reservations/:id
  def destroy
    reservation = current_user.reservations.find_by!(id: params[:id], room_id: @room.id)
    reservation.destroy
    redirect_to reservations_path, notice: "予約を削除しました。"
  rescue ActiveRecord::RecordNotFound
    redirect_to reservations_path, alert: "予約が見つかりません。"
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :people_count)
  end
end
