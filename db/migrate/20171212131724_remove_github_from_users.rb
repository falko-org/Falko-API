class RemoveGithubFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :github, :string
  end
end
