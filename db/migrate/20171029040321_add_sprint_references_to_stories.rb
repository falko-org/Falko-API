class AddSprintReferencesToStories < ActiveRecord::Migration[5.1]
  def change
    add_reference :stories, :sprint, foreign_key: true
  end
end
