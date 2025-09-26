class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rooms, dependent: :destroy, inverse_of: :user
  has_many :reservations, dependent: :destroy
  has_many :booked_rooms, through: :reservations, source: :room

  has_one_attached :avatar

  # ▼ ここから追加（2-2）
  validates :name, presence: true

  # Devise は email と password の存在・形式は見るが、
  # 「確認用の空」を落としきれないことがあるので create では明示的に必須にする
  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
end

