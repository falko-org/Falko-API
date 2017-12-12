class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.Float :weight_burndown
      t.Float :weight_velocity
      t.Float :weight_debt

      t.timestamps
    end
  end
end
