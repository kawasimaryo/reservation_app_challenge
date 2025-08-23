class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ---- Associations ----
  # オーナーとして「自分が作成した施設」
  has_many :rooms, dependent: :destroy, inverse_of: :user

  # 借りる側としての予約
  has_many :reservations, dependent: :destroy

  # （任意）自分が「予約した施設」を参照したいときの別名
  # current_user.booked_rooms で取得できる
  has_many :booked_rooms, through: :reservations, source: :room

  # ---- Avatar（ユーザーアイコン）----
  # Active Storage を利用して1つの画像を添付できる
  has_one_attached :avatar
end
