class AddSprintReferencesToRevisions < ActiveRecord::Migration[5.1]
  def change
    add_reference :revisions, :sprint, foreign_key: true
  end
end
