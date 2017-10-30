class AddGithubSlugToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :github_slug, :string
  end
end
