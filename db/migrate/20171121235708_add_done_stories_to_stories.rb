class AddDoneStoriesToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :done_stories, :string, array: true, default: []
  end
end
