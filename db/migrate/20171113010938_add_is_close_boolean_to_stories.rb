class AddIsCloseBooleanToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :is_close, :boolean
  end
end
