class Room < ApplicationRecord
  # ---- Associations ----
  # 所有者（オーナー）
  belongs_to :user, inverse_of: :rooms

  # 借りる側の予約情報
  has_many :reservations, dependent: :destroy
  has_many :guests, through: :reservations, source: :user

  # 画像（Active Storage）
  has_one_attached :image

  # ---- Validations ----
  validates :name,        presence: true
  validates :description, presence: true
  validates :address,     presence: true
  validates :price,       presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # （任意）画像の簡単なバリデーションを入れたい場合
  validate :image_content_type

  private

  def image_content_type
    return unless image.attached?
    unless image.content_type&.start_with?("image/")
      errors.add(:image, "は画像ファイルを添付してください")
    end
  end
end