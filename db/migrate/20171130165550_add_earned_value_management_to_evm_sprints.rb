class AddEarnedValueManagementToEvmSprints < ActiveRecord::Migration[5.1]
  def change
    add_reference :evm_sprints, :earned_value_management, foreign_key: true
  end
end
