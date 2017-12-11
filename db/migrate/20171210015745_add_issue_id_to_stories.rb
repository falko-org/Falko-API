class AddIssueIdToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :issue_id, :integer
  end
end
