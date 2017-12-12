class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.float :weight_burndown
      t.float :weight_velocity
      t.float :weight_debts

      t.timestamps
    end
  end
end
