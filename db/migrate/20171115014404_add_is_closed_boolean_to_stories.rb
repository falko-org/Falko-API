class AddIsClosedBooleanToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :is_closed, :boolean
  end
end
