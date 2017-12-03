class AddProjecIdToEpics < ActiveRecord::Migration[5.1]
  def change
    add_column :epics, :project_id, :integer
  end
end
