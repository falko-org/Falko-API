module MetricHelper
  include BurndownHelper
  include VelocityHelper

  def get_metrics(grade)
    last_release = grade.project.releases.last
    metrics = calculate_metrics(last_release)

    sum_of_weights = grade.weight_debt + grade.weight_velocity + grade.weight_burndown

    final_metric = Float (grade.weight_debt * metrics[:metric_debts_value] +
                          grade.weight_velocity * metrics[:metric_velocity_value] +
                          grade.weight_burndown * metrics[:metric_burndown_value]) /
                          sum_of_weights
  end

  def calculate_metrics(release)
    sprint = release.sprints.last

    if release.project.is_scoring == true
      burned_stories = {}
      date_axis = []
      points_axis = []
      ideal_line = []
      metric_burndown_array = []
      amount_of_sprints = release.sprints.count
      metric_velocity_value = 0
      planned_points = 0
      burned_points = 0

      velocity = get_sprints_informations(release.sprints, sprint)
      total_points = get_total_points(sprint)
      burned_stories = get_burned_points(sprint, burned_stories)
      total_sprints_points = velocity[:total_points]
      velocities = velocity[:velocities]

      range_dates = (sprint.initial_date .. sprint.final_date)

      set_dates_and_points(burned_stories, date_axis, points_axis, range_dates, total_points)
      days_of_sprint = date_axis.length - 1
      set_ideal_line(days_of_sprint, ideal_line, total_points)
      ideal_burned_points = ideal_line[0] - ideal_line[1]

      for i in 0..(date_axis.length - 2)
        real_burned_points = points_axis[i] - points_axis[i + 1]
        burned_percentage = Float((real_burned_points).abs * 100) / ideal_burned_points
        metric_burndown_array.push(burned_percentage)
      end

      for i in 0..(amount_of_sprints - 1)
        metric_velocity_value += (total_sprints_points[i] - velocities[i])
      end

      for i in 0..(release.sprints.length - 1)
        planned_points += velocity[:total_points][i]
        burned_points += velocity[:completed_points][i]
      end

      metric_burndown_value = calculate_burndown(metric_burndown_array)

      metric_debts_value = Float(planned_points - burned_points) / planned_points
      metric_debts_value = calculate_velocity_and_debt(metric_debts_value)

      total_points = get_total_points_release(release)
      metric_velocity_value = Float metric_velocity_value / total_points
      metric_velocity_value = calculate_velocity_and_debt(metric_velocity_value)

      return metrics = { metric_debts_value: metric_debts_value,
                  metric_velocity_value: metric_velocity_value,
                  metric_burndown_value: metric_burndown_value }
    end
  end

  def calculate_velocity_and_debt(metric)
    values = 0

    if metric <= 0.2
      values += 4
    elsif metric <= 0.4
      values += 3
    elsif metric <= 0.6
      values += 2
    elsif metric <= 0.9
      values += 1
    elsif metric <= 1
      values += 0
    end

    return values
  end

  def calculate_burndown(metric)
    values = 0

    for i in 0..(metric.length - 1)
      if metric[i] <= 10 || metric[i] > 100
        values += 0
      elsif metric[i] <= 40
        values += 1
      elsif metric[i] <= 60
        values += 2
      elsif metric[i] <= 80
        values += 3
      elsif metric[i] <= 100
        values += 4
      end
    end

    return Float values / metric.length
  end
end
