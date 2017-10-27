class AddCheckProjectToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :check_project, :boolean
  end
end
