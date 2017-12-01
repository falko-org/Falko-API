class AddReleaseReferencesToEarnedValueManagement < ActiveRecord::Migration[5.1]
  def change
    add_reference :earned_value_managements, :release, foreign_key: true
  end
end
