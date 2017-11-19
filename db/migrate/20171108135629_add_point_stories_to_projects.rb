class AddPointStoriesToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :is_scoring, :boolean
  end
end
