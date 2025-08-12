class Room < ApplicationRecord
  # ↓↓↓ この行を追加！「施設は一人の所有者(user)に属する」という意味 ↓↓↓
  belongs_to :user

  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  # ↓↓↓ ここから下がバリデーションルール ↓↓↓
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true
end