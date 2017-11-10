class AddPointsToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :story_points, :integer
  end
end
