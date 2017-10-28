class Sprint < ApplicationRecord
  belongs_to :release

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :initial_date, presence: true
  validates :final_date, presence: true

  validate :is_final_date_valid?

  private
    def is_final_date_valid?
      # Verifies if dates exist, and if final date is after initial date
      if self[:initial_date] && self[:final_date] && self[:final_date] < self[:initial_date]
        errors.add(:final_date, "Final date cannot be in the past")
      end
    end
end
