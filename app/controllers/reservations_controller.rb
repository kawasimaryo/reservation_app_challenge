class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:user, :room).all
  end

  def new
    @reservation = Reservation.new
    @users = User.all
    @rooms = Room.all
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path, notice: '予約が作成されました'
    else
      @users = User.all
      @rooms = Room.all
      render :new, status: :unprocessable_entity
    end
  end

  # --- ここから下を追加 ---

  # 編集フォームを表示するためのアクション
  def edit
    @reservation = Reservation.find(params[:id])
    # 編集フォームでユーザーや部屋を選び直せるように、一覧を取得しておく
    @users = User.all
    @rooms = Room.all
  end

  # 更新処理を行うためのアクション
  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update(reservation_params)
      redirect_to reservations_path, notice: '予約を更新しました。'
    else
      # 更新に失敗した場合も、編集フォームを再表示するために一覧が必要
      @users = User.all
      @rooms = Room.all
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除を実行するためのアクション
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to reservations_path, notice: '予約を削除しました。'
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :user_id,
      :room_id,
      :start_date,
      :end_date,
      :people_count # :people_countは君のスキーマに合わせてある
    )
  end
end


