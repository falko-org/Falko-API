module VelocityHelper
  def calculate_points(sprint)
    sprint_total_points = 0
    sprint_completed_points = 0

    sprint.stories.each do |story|
      sprint_total_points += story.story_points
      if story.pipeline == "Done"
        sprint_completed_points += story.story_points
      end
    end

    points = { sprint_total_points: sprint_total_points, sprint_completed_points: sprint_completed_points }
  end

  def get_sprints_informations(sprints, actual_sprint)
    names = []
    total_points = []
    completed_points = []
    velocities = []
    points = {}

    sprints.each do |sprint|
      if actual_sprint.final_date >= sprint.final_date
        names.push(sprint.name)

        points = calculate_points(sprint)

        total_points.push(points[:sprint_total_points])
        completed_points.push(points[:sprint_completed_points])
        velocities.push(calculate_velocity(completed_points))
      end
    end

    sprints_informations = { total_points: total_points, completed_points: completed_points, names: names, velocities: velocities }
  end

  def calculate_velocity(completed_points)
    size = completed_points.size
    total_completed_points = 0

    completed_points.each do |point|
      total_completed_points += point
    end

    return Float(total_completed_points) / size
  end
end
