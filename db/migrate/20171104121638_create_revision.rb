class CreateRevision < ActiveRecord::Migration[5.1]
  def change
    create_table :revisions do |t|
      t.text :done_report, array: true, defaut: []
      t.text :undone_report, array: true, defaut: []

      t.timestamps
    end
  end
end
