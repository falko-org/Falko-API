class AddAuthenticatedFieldToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :confirmation_token, :boolean, default: false
  end
end
