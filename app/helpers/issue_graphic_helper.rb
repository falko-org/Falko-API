module IssueGraphicHelper
  def get_issues_graphic(actual_date, option, issues)
    first_date = actual_date - 3.month
    number_of_issues = {}
    dates = []
    total_open_issues = [0, 0, 0]
    total_closed_issues = [0, 0, 0]

    if option == "month"
      dates = [(actual_date - 2.month).strftime("%B"), (actual_date - 1.month).strftime("%B"), (actual_date).strftime("%B")]
    end

    issues.each do |issue|
      if issue.created_at.to_date <= actual_date && issue.created_at.to_date >= first_date
        created_issues(issue, total_open_issues, actual_date)
        closed_issues(issue, total_closed_issues, actual_date)
      end
    end
    number_of_issues = { opened_issues: total_open_issues, closed_issues: total_closed_issues, months: dates }
    return number_of_issues
  end

  def created_issues (issue, total_open_issues, actual_date)
    if issue.created_at.to_date.month == actual_date.month
      total_open_issues[2] = total_open_issues[2] + 1
    elsif issue.created_at.to_date.month == (actual_date - 1.month).month
      total_open_issues[1] = total_open_issues[1] + 1
    else
      total_open_issues[0] = total_open_issues[0] + 1
    end
  end

  def closed_issues (issue, total_closed_issues, actual_date)
    if issue.closed_at != nil
      if issue.closed_at.to_date.month == actual_date.month
        total_closed_issues[0] = total_closed_issues[0] + 1
      elsif issue.closed_at.to_date.month == (actual_date - 1.month).month
        total_closed_issues[1] = total_closed_issues[1] + 1
      else
        total_closed_issues[2] = total_closed_issues[2] + 1
      end
    end
  end
end
