class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # --- 基本バリデーション ---
  validates :start_date, :end_date, :people_count, presence: true
  validates :people_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # --- カスタムバリデーション ---
  validate :start_date_cannot_be_in_the_past
  validate :end_date_cannot_be_before_start_date

  # --- 派生値（表示/計算用） ---
  def nights
    return 0 unless start_date.present? && end_date.present?
    (end_date - start_date).to_i
  end

  # 合計金額 = 宿泊日数 × 人数 × 施設の料金(/日)
  def total_price
    return 0 if room.blank?
    nights * people_count.to_i * room.price.to_i
  end

  private

  def start_date_cannot_be_in_the_past
    return if start_date.blank?
    errors.add(:start_date, "は過去の日付にできません") if start_date < Date.current
  end

  def end_date_cannot_be_before_start_date
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "は開始日より後の日付にしてください") if end_date <= start_date
  end
end