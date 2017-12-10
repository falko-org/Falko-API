class EvmSprintObserver < ActiveRecord::Observer
  observe :earned_value_management

  def after_save(evm_sprints)
    if planned_sprints_changed?
      evm_sprints.update(earned_value_management_params)
    end
  end

  def after_destroy(evm_sprints)
    evm_sprints.destroy
  end
end
