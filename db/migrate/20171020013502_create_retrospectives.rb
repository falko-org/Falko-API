class CreateRetrospectives < ActiveRecord::Migration[5.1]
  def change
    create_table :retrospectives do |t|
      t.text :sprint_report
      t.text :positive_points
      t.text :negative_points
      t.text :improvements

      t.timestamps
    end
  end
end
