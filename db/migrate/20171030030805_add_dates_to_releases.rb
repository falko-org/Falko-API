class AddDatesToReleases < ActiveRecord::Migration[5.1]
  def change
    add_column :releases, :initial_date, :date
    add_column :releases, :final_date, :date
  end
end
