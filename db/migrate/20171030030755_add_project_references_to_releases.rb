class AddProjectReferencesToReleases < ActiveRecord::Migration[5.1]
  def change
    add_reference :releases, :project, foreign_key: true
  end
end
