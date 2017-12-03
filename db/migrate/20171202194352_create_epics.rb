class CreateEpics < ActiveRecord::Migration[5.1]
  def change
    create_table :epics do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
