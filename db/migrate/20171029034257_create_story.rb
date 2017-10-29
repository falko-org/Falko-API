class CreateStory < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :description
      t.string :assign
      t.string :pipeline
    end
  end
end
