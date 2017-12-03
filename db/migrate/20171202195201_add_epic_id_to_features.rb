class AddEpicIdToFeatures < ActiveRecord::Migration[5.1]
  def change
    add_column :features, :epic_id, :integer
  end
end
