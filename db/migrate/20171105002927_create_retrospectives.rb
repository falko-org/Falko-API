class CreateRetrospectives < ActiveRecord::Migration[5.1]
  def change
    create_table :retrospectives do |t|
      t.text :sprint_report
      t.text :positive_points, array: true, default: []
      t.text :negative_points, array: true, default: []
      t.text :improvements, array: true, default: []

      t.timestamps
    end
  end
end
