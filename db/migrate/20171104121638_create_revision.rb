class CreateRevision < ActiveRecord::Migration[5.1]
  def change
    create_table :revisions do |t|
      t.text :done_report
      t.text :undone_report

      t.timestamps
    end
  end
end
