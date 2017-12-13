 module EarnedValueManagementHelper
   def calculate_evm_sprint_values(evm, evm_sprint)
     calculate_planned_sprints(evm)

     evm_sprint.current_sprint = get_current_sprint(evm.planned_sprints)

     evm_sprint.planned_percent_completed = calculate_ppc(
       evm_sprint.current_sprint,
       evm.planned_sprints
     )

     evm_sprint.actual_percent_completed = calculate_apc(
       evm_sprint.completed_points,
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

     accumulated_values = calculate_accumulated_values(evm, evm_sprint)

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

   def calculate_planned_sprints(evm)
     evm.update(planned_sprints: evm.evm_sprints.size + 1)
   end

   def get_current_sprint(planned_sprints)
     current_sprint = planned_sprints
   end

   #issue: Always return 1
   #issue: Must be updated in all sprints when a new sprint is created/updated
   def calculate_ppc(current_sprint, planned_sprints)
     begin
       planned_percent_completed = Float(current_sprint) / planned_sprints
     rescue ZeroDivisionError
       return 0
     end
     return planned_percent_completed
   end

   #issue: Must be updated in all sprints when a new sprint is created/updated
   #issue: Must be an accumulated value
   def calculate_apc(completed_points, planned_release_points)
     begin
       actual_percent_completed = Float(completed_points) / planned_release_points
     rescue ZeroDivisionError
       return 1.0
     end
     return actual_percent_completed
   end

   #issue: Must be updated in all sprints when a new sprint is created/updated
   def calculate_pv(planned_percent_completed, budget_actual_cost)
     planned_value = planned_percent_completed * budget_actual_cost
   end

   def calculate_av(budget_actual_cost, planned_release_points, completed_points)
     begin
       actual_value = (Float (budget_actual_cost) / planned_release_points) * completed_points
     rescue ZeroDivisionError
       return 0
     end
     return actual_value
   end

   def calculate_ev(actual_percent_completed, budget_actual_cost)
     earned_value = actual_percent_completed * budget_actual_cost
   end

   #issue: Must be updated in all sprints when a new sprint is created/updated
   #note: Already updates apv, aav and aev, but I don't know if it's running corectly
   def calculate_accumulated_values(evm, evm_sprint)
     accumulated_planned_value = evm_sprint.planned_value
     accumulated_actual_value = evm_sprint.actual_value
     accumulated_earned_value = evm_sprint.earned_value

     evm.evm_sprints.each_with_index do |sprint, index|
       if (index < evm_sprint.current_sprint)
         accumulated_planned_value += sprint.planned_value
         accumulated_actual_value += sprint.actual_value
         accumulated_earned_value += sprint.earned_value
       end
     end

     accumulated_values = {
       apv: accumulated_planned_value,
       aav: accumulated_actual_value,
       aev: accumulated_earned_value
     }
   end

   #issue: Must be updated in all sprints when a new sprint is created/updated
   def calculate_cv(earned_value, planned_value)
     cost_variance = earned_value - planned_value
   end

   def calculate_sv(earned_value, actual_value)
     schedule_variance = earned_value - actual_value
   end

   def calculate_cpi(earned_value, actual_value)
     begin
       cost_performance_index = Float(earned_value) / actual_value
     rescue ZeroDivisionError
       return earned_value
     end
     return cost_performance_index
   end

   #issue: Must be updated in all sprints when a new sprint is created/updated
   def calculate_spi(earned_value, planned_value)
     begin
       schedule_performance_index = Float(earned_value) / planned_value
     rescue ZeroDivisionError
       return planned_value
     end
     return schedule_performance_index
   end

   def calculate_etc(cost_performance_index, budget_actual_cost, earned_value)
     begin
       estimate_to_complete = (1.0 / cost_performance_index) * budget_actual_cost - earned_value
     rescue ZeroDivisionError
       estimate_to_complete = budget_actual_cost - earned_value
     end
     return estimate_to_complete
   end

   def calculate_eac(actual_value, estimate_to_complete)
     estimate_at_complete = actual_value + estimate_to_complete
   end
end
