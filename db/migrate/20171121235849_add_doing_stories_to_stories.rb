class AddDoingStoriesToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :doing_stories, :string, array: true, default: []
  end
end
