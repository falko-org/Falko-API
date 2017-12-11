module BurndownHelper
  def get_burned_points(sprint, burned_stories)
    for story in sprint.stories
      if story.pipeline == "Done"
        if burned_stories[story.final_date] == nil
          burned_stories[story.final_date] = story.story_points
        else
          burned_stories[story.final_date] += story.story_points
        end
      end
    end

    return burned_stories
  end

  def get_total_points(sprint)
    total_points = 0

    for story in sprint.stories
      total_points += story.story_points
    end

    return total_points
  end

  def get_dates(burned_stories, date_axis, points_axis, range_dates, total_points)
    range_dates.each do |date|
      if burned_stories[date] == nil
        burned_stories[date] = total_points
      else
        total_points -= burned_stories[date]
        burned_stories[date] = total_points
      end
      date_axis.push(date)
      points_axis.push(burned_stories[date])
    end
  end

  def set_ideal_line(days_of_sprint, ideal_line, planned_points)
    for day in (days_of_sprint).downto(0)
      ideal_line.push(planned_points * (day / (Float days_of_sprint)))
    end
  end
end
