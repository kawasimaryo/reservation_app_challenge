class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # --- 基本バリデーション ---
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :people_count, presence: true,
                           numericality: { only_integer: true, greater_than: 0 }

  # --- 日付の整合性チェック ---
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "は開始日より後にしてください")
    end
  end
end

