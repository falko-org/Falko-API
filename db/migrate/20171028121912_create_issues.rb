class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :body
      t.string :assignee
      t.integer :milestone
      t.string :labels
      t.string :assignees

      t.timestamps
    end
  end
end
