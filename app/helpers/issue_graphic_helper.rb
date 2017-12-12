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
        interval_issues(issue, total_open_issues, actual_date)
        if issue.closed_at != nil
          interval_issues(issue, total_closed_issues, actual_date)
        end
      end
    end
    number_of_issues = { opened_issues: total_open_issues, closed_issues: total_closed_issues, months: dates }
    return number_of_issues
  end

  def interval_issues (issue, total_open_issues, actual_date)
    last_month = actual_date - 1.month
    if issue.created_at.to_date.month == actual_date.month
      increment_total(total_open_issues, 2)
    elsif issue.created_at.to_date.month == last_month.month
      increment_total(total_open_issues, 1)
    else
      increment_total(total_open_issues, 0)
    end
  end

  def increment_total(total, position)
    total[position] = total[position] + 1
  end
end
