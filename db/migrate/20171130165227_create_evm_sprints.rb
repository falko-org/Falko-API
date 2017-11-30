class CreateEvmSprints < ActiveRecord::Migration[5.1]
  def change
    create_table :evm_sprints do |t|
      t.float :planned_percent_completed
      t.float :actual_percent_completed
      t.integer :completed_points
      t.integer :added_points
      t.integer :current_sprint
      t.float :planned_value
      t.float :actual_value
      t.float :earned_value
      t.float :accumulated_planned_value
      t.float :accumulated_actual_value
      t.float :accumulated_earned_value
      t.float :cost_variance
      t.float :schedule_variance
      t.float :cost_performance_index
      t.float :schedule_performance_index
      t.float :estimate_to_complete
      t.float :estimate_at_complete

      t.timestamps
    end
  end
end
