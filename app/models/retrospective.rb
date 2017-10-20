class Retrospective < ApplicationRecord

  belongs_to :sprint

  validates :sprint_report, length: { maximum: 1500, minimum: 0 }
  validates :positive_points, length: { maximum: 500, minimum: 0 }
  validates :negative_points, length: { maximum: 500, minimum: 0 }
  validates :improvements, length: { maximum: 500, minimum: 0 }


end
