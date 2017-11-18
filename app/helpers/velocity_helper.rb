module VelocityHelper

  def calculate_velocity(completed_points)
    size = completed_points.size
    total_completed_points = 0

    completed_points.each do |point|
      total_completed_points += point
    end

    return Float(total_completed_points)/size
  end
end
