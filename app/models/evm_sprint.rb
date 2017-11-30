class EvmSprint < ApplicationRecord
  belongs_to :earned_value_management

  # completed_points => Points completed during the sprint
  # added_points => Points added to the backlog
  # Attributes:
  # planned_percent_completed => Release's percent completed expected at this sprint
  # actual_percent_completed => Release's percent completed at this sprint
  # current_sprint =>
  # planned_value =>
  # actual_value
  # earned_value
  # accumulated_planned_value
  # accumulated_actual_value
  # accumulated_earned_value
  # cost_variance
  # schedule_variance
  # cost_performance_index
  # schedule_performance_index
  # estimate_to_complete
  # estimate_at_complete

  validates

end
