class CreateStory < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :description
      t.string :assign
      t.string :pipeline
      t.string :sprint_id
      t.date :start_date
      t.date :conclusion_date
    end
  end
end
