class Release < ApplicationRecord
  validates :name, presence: true, length:{in: 2..80}
  validates :description, length: { maximum: 256 }
  validates :initial_date, presence: true
  validates :final_date, presence: true 
end
