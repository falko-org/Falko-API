class AddIsProjectFromGithubToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :is_project_from_github, :boolean
  end
end
