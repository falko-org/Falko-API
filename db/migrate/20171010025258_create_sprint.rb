class CreateSprint < ActiveRecord::Migration[5.1]
  def change
    create_table :sprints do |t|
      t.string :name
      t.text :description
      t.string :project_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
