class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :people_count, presence: true, numericality: { greater_than_or_equal_to: 1 }

  # --- カスタムバリデーション ---
  validate :start_date_cannot_be_in_the_past # この行を追加
  validate :end_date_cannot_be_before_start_date

  private

  # ↓↓↓ このメソッドを追加 ↓↓↓
  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "は過去の日付にできません")
    end
  end

  def end_date_cannot_be_before_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "は開始日より後の日付にしてください")
    end
  end
end

