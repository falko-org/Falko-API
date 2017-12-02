class AddFeatureIdToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :feature_id, :integer
  end
end
