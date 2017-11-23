module VelocityHelper

  def get_sprints_informations(sprints)
    names = []
    total_points = []
    completed_points = []
    velocities = []

    sprints.each do |sprint|
      names.push(sprint.name)

      sprint_total_points = 0
      sprint_completed_points = 0

      sprint.stories.each do |story|
        sprint_total_points += story.story_points

        if story.pipeline == "Done"
          sprint_completed_points += story.story_points
        end
      end

      total_points.push(sprint_total_points)
      completed_points.push(sprint_completed_points)
      velocities.push(calculate_velocity(completed_points))
    end

    sprints_informations = { total_points: total_points, completed_points: completed_points, names: names, velocities: velocities }
  end

  def calculate_velocity(completed_points)
    size = completed_points.size
    total_completed_points = 0

    completed_points.each do |point|
      total_completed_points += point
    end

    return Float(total_completed_points)/size
  end
end
