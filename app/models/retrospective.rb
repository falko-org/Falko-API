class Retrospective < ApplicationRecord
  belongs_to :sprint

  validates :sprint_report, length: { maximum: 1500 }
  validates :positive_points, presence: true, length: { maximum: 500 }
  validates :negative_points, presence: true, length: { maximum: 500 }
  validates :improvements, presence: true, length: { maximum: 500 }
end
