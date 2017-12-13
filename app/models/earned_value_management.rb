class EarnedValueManagement < ApplicationRecord
  belongs_to :release
  has_many :evm_sprints

  # Attributes:
  # budget_actual_cost => Release total cost. Currency format. User input
  # planned_release_points => Total points planned for the release. Numeric user input
  # planned_sprints => Number of sprints in the release

  validates :budget_actual_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :planned_release_points, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
