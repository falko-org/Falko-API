class AddDatesToSprints < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :initial_date, :date
    add_column :sprints, :final_date, :date
  end
end
