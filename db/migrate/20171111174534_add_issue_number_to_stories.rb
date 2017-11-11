class AddIssueNumberToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :issue_number, :string
  end
end
