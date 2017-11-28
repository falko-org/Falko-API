class AddFeatureReferencesToStories < ActiveRecord::Migration[5.1]
  def change
    add_reference :stories, :feature, foreign_key: true
  end
end
