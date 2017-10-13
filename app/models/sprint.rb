class Sprint < ApplicationRecord

  belongs_to :project, dependent: :destroy
  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :is_final_date_valid?

  private
  def is_final_date_valid?
    # It verifies if the dates exist and if end date is after start date.
    if self[:start_date] && self[:end_date] && self[:end_date] < self[:start_date]
      errors.add(:end_date, "Start date must begins before end date!")
    end
  end

end
