module ValidateDateHelper
  def is_final_date_valid?
    # Verifies if dates exist, and if final date is after initial date
    if self[:initial_date] && self[:final_date] && self[:final_date] < self[:initial_date]
      errors.add(:final_date, "Final date cannot be in the past")
    end
  end
end
