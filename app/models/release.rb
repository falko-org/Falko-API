class Release < ApplicationRecord
  validates :name, presence: true, length:{in: 2..80}
  validates :description, length:{in: 5..256}
  validates :amount_of_sprints, presence: true
end
