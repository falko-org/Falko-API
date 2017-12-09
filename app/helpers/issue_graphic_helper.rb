module IssueGraphicHelper
  def get_issues_graphic(actual_date, option, issues)
    first_date = actual_date - 3.month

    number_of_issues = {}

    closed_issues_first = 0
    open_issues_first = 0

    closed_issues_second = 0
    open_issues_second = 0

    closed_issues_third = 0
    open_issues_third = 0

    total_closed_issues = []
    total_open_issues = []

    dates = []

    if option == "month"
      dates = [(actual_date - 2.month).strftime('%B'), (actual_date - 1.month).strftime('%B'), (actual_date).strftime('%B')]
    end


    issues.each do |issue|
      if issue.created_at.to_date <= actual_date && issue.created_at.to_date >= first_date
        if issue.closed_at == nil
          if issue.created_at.to_date.month == actual_date.month
            open_issues_first = open_issues_first + 1
          elsif issue.created_at.to_date.month - 1.month == actual_date.month
            open_issues_second = open_issues_second + 1
          else
            open_issues_third = open_issues_third + 1
          end
        else
          if issue.closed_at.to_date.month == actual_date.month
            closed_issues_first = closed_issues_first + 1
          elsif issue.closed_at.to_date.month - 1.month == actual_date.month
            closed_issues_second = closed_issues_second + 1
          else
            closed_issues_third = closed_issues_third + 1
          end
        end
      end
    end

    total_open_issues.push(open_issues_third)
    total_open_issues.push(open_issues_second)
    total_open_issues.push(open_issues_first)

    total_closed_issues.push(closed_issues_third)
    total_closed_issues.push(closed_issues_second)
    total_closed_issues.push(closed_issues_first)

    number_of_issues = { opened_issues: total_open_issues, closed_issues: total_closed_issues, months: dates}
    return number_of_issues
  end
end
