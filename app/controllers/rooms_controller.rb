class RoomsController < ApplicationController
  # :show / :search は未ログインでも閲覧可（検索結果から他人の施設詳細へ遷移できるように）
  before_action :authenticate_user!, except: [:show, :search]
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  AREAS = %w[東京 大阪 京都 札幌].freeze

  # ===== 自分が作成した施設一覧（要ログイン） =====
  def index
    @rooms = current_user.rooms.order(created_at: :desc)
  end

  # ===== 施設詳細（誰でも閲覧可） =====
  def show
    @reservation = Reservation.new
  end

  # ===== 施設検索（誰でも閲覧可） =====
  # 住所: エリア（東京/大阪/京都/札幌）を対象に「あいまい検索」
  # 施設名・詳細: フリーワード「あいまい検索」
  # 画面では @total, @rooms を表示
  def search
    @area    = params[:area].to_s.strip
    @keyword = params[:keyword].to_s.strip

    scope = Room.all
    scope = scope.where("address LIKE ?", "%#{@area}%") if @area.present? && AREAS.include?(@area)
    scope = scope.where("name LIKE :q OR description LIKE :q", q: "%#{@keyword}%") if @keyword.present?

    @rooms = scope.order(created_at: :desc)
    @total = @rooms.size
  end

  # ===== 新規作成（要ログイン） =====
  def new
    @room = Room.new
  end

  def create
    # user_id は外部から受け取らず、必ず current_user を関連付ける
    @room = Room.new(room_params)
    @room.user = current_user

    if @room.save
      redirect_to @room, notice: "施設を登録しました。"
    else
      Rails.logger.warn("[ROOMS#create] validation errors: #{@room.errors.full_messages}")
      render :new
    end
  end

  # ===== 編集 / 更新 / 削除（自分の施設のみ） =====
  def edit; end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: "施設情報を更新しました。"
    else
      Rails.logger.warn("[ROOMS#update] validation errors: #{@room.errors.full_messages}")
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "施設を削除しました。"
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_user
    return if user_signed_in? && @room.user_id == current_user.id

    redirect_to root_path, alert: "権限がありません。"
  end

  def room_params
    # :user_id は受け取らない（current_user を強制適用）
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end