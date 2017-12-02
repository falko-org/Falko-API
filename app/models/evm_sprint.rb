class EvmSprint < ApplicationRecord
  belongs_to :earned_value_management

  validates :completed_points, presence: true

end
