class AddProjectsToGrades < ActiveRecord::Migration[5.1]
  def change
  	add_reference :grades, :project, foreign_key: true
  end
end
