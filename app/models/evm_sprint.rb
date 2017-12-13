class EvmSprint < ApplicationRecord
  belongs_to :earned_value_management

  validates :completed_points, presence: true
  validates :added_points, presence: true

  # Attributes:
  # completed_points => Points completed during the sprint
  # addded_points => Points added to the backlog
  # planned_percent_completed => Release's percent completed expected at this sprint
  # actual_percent_completed => Release's percent completed at this sprint
  # current_sprint =>
  # actual_value
  # accumulated_planned_value
  # accumulated_actual_value
  # accumulated_earned_value

  #results
  # planned_value =>
  # earned_value
  # schedule_variance
  # cost_variance
  # cost_performance_index
  # schedule_performance_index
  # estimate_to_complete
  # estimate_at_complete
end
