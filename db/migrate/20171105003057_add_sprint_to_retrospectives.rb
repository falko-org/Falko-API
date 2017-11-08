class AddSprintToRetrospectives < ActiveRecord::Migration[5.1]
  def change
    add_reference :retrospectives, :sprint, foreign_key: true
  end
end
