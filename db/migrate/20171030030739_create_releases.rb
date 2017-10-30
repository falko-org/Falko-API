class CreateReleases < ActiveRecord::Migration[5.1]
  def change
    create_table :releases do |t|
      t.string :name
      t.text :description
      t.integer :amount_of_sprints

      t.timestamps
    end
  end
end
