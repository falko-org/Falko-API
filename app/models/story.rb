class Story < ApplicationRecord
  belongs_to :sprint

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :assign, length: { maximum: 32, minimum: 2 }
  validates :pipeline, length: { maximum: 16, minimum: 4 }
  validates :start_date, presence: true

  validate :is_final_date_valid?

  private
    def is_final_date_valid?
      # It verifies if the dates exist and if end date is after start date.
      if self[:start_date] && self[:conclusion_date] && self[:conclusion_date] < self[:start_date]
        errors.add(:conclusion_date, "Start date must begins before end date!")
      end
    end
end
