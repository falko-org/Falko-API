class AddDatesToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :initial_date, :date
    add_column :stories, :final_date, :date
  end
end
