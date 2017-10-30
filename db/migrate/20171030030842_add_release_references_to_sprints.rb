class AddReleaseReferencesToSprints < ActiveRecord::Migration[5.1]
  def change
    add_reference :sprints, :release, foreign_key: true
  end
end
