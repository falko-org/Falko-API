class AddProjectReferencesToFeatures < ActiveRecord::Migration[5.1]
  def change
    add_reference :features, :project, foreign_key: true
  end
end
