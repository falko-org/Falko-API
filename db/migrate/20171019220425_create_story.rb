class CreateStory < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.text :title
      t.text :body
      t.string :assignee
      t.string :milestone
      t.string :labels
      t.string :assignees
    end
  end
end
