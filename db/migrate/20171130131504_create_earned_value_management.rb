class CreateEarnedValueManagement < ActiveRecord::Migration[5.1]
  def change
    create_table :earned_value_management do |t|
      t.float :budget_actual_cost
      t.integer :planned_sprints
      t.integer :planned_release_points

      t.timestamps
    end
  end
end
