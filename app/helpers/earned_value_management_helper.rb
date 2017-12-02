 module EarnedValueManagementHelper

  def calculate_evm_sprint_values(evm, evm_sprint)
    evm.planned_sprints = evm.evm_sprints.size

    evm_sprint.current_sprint = get_current_sprint(evm.planned_sprints)

    evm_sprint.planned_percent_completed = calculate_ppc(
      evm_sprint.current_sprint,
      evm.planned_sprints
    )

    evm_sprint.actual_percent_completed = calculate_apc(
      evm.completed_points,
      evm.planned_release_points
    )

    evm_sprint.planned_value = calculate_pv(
      evm_sprint.planned_percent_completed,
      evm.budget_actual_cost
    )

    evm_sprint.actual_value = calculate_av(
      evm.budget_actual_cost,
      evm.planned_release_points,
      evm_sprint.completed_points
    )

     evm_sprint.earned_value = calculate_ev(
      evm_sprint.actual_percent_completed,
      evm.budget_actual_cost
    )

    accumulated_values = calculate_accumulated_values(evm)

    evm_sprint.accumulated_planned_value = accumulated_values[:apv]
    evm_sprint.accumulated_actual_value = accumulated_values[:aav]
    evm_sprint.accumulated_earned_value = accumulated_values[:aev]

    evm_sprint.cost_variance = calculate_cv(
      evm_sprint.earned_value,
      evm_sprint.planned_value
    )

    evm_sprint.schedule_variance = calculate_sv(
      evm_sprint.earned_value,
      evm_sprint.actual_value
    )

    evm_sprint.cost_performance_index = calculate_cpi(
      evm_sprint.earned_value,
      evm_sprint.actual_value
    )

    evm_sprint.schedule_performance_index = calculate_spi(
      evm_sprint.earned_value,
      evm_sprint.planned_value
    )

    evm_sprint.estimate_to_complete = calculate_etc(
      evm_sprint.cost_performance_index,
      evm.budget_actual_cost,
      evm_sprint.earned_value
    )

    evm_sprint.estimate_at_complete = calculate_eac(
      evm_sprint.actual_value,
      evm_sprint.estimate_to_complete
    )
  end

  def get_current_sprint(planned_sprints)
    current_sprint = planned_sprints + 1
  end

  def calculate_ppc(current_sprint, planned_sprints)
    planned_percent_completed = current_sprint / planned_sprints
  end

  def calculate_apc(completed_points, planned_release_points)
    actual_percent_completed = completed_points / planned_release_points
  end

  def calculate_pv(planned_percent_completed, budget_actual_cost)
    planned_value = planned_percent_completed * budget_actual_cost
  end

  def calculate_av(budget_actual_cost, planned_release_points, completed_points)
    actual_value = (budget_actual_cost / planned_release_points) * completed_points
  end

  def calculate_ev(actual_percent_completed, budget_actual_cost)
    earned_value = actual_percent_completed * budget_actual_cost
  end

  def calculate_accumulated_values(evm)
    accumulated_planned_value = 0
    accumulated_actual_value = 0
    accumulated_earned_value = 0

    evm.evm_sprints.each do |evm_sprint, index|
      if index < evm_sprint.current_sprint
        accumulated_planned_value += evm_sprint.planned_value
        accumulated_actual_value += evm_sprint.actual_value
        accumulated_earned_value += evm_sprint.earned_value
      end
    end

    accumulated_values = {
      apv: accumulated_planned_value,
      aav: accumulated_actual_value,
      aev: accumulated_earned_value
    }
  end

  def calculate_cv(earned_value, planned_value)
    cost_variance = earned_value - planned_value
  end

  def calculate_sv(earned_value, actual_value)
    schedule_variance = earned_value - actual_value
  end

  def calculate_cpi(earned_value, actual_value)
    cost_performance_index = earned_value / actual_value
  end

  def calculate_spi(earned_value, planned_value)
    schedule_performance_index = earned_value / planned_value
  end

  def calculate_etc(cost_performance_index, budget_actual_cost, earned_value)
    estimate_to_complete = (1 / cost_performance_index) * budget_actual_cost - earned_value
  end

  def calculate_eac(actual_value, estimate_to_complete)
    estimate_at_complete = actual_value + estimate_to_complete
  end
end
