require "test_helper"

class VelocityHelperTest < ActiveSupport::TestCase
  include VelocityHelper

  def setup
    @user = User.create(
      name: "Ronaldo",
      email: "Ronaldofenomeno@gmail.com",
      password: "123456789",
      password_confirmation: "123456789"
    )

    @project = Project.create(
      name: "Falko",
      description: "Some project description.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: true
    )

    @release = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @first_sprint = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "06/10/2016",
      final_date: "13/10/2018",
      release_id: @release.id,
    )

    @second_sprint = Sprint.create(
      name: "Sprint 2",
      description: "Sprint 2 us10",
      initial_date: "06/10/2016",
      final_date: "13/10/2018",
      release_id: @release.id,
    )

    @first_story = Story.create(
      name: "Story 1",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "In Progress",
      initial_date: "01/01/2017",
      issue_number: "8",
      sprint_id: @first_sprint.id,
      story_points: "5"
    )

    @second_story = Story.create(
      name: "Story 2",
      description: "Story 2 us14",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/01/2017",
      final_date: "01/02/2017",
      issue_number: "9",
      sprint_id: @first_sprint.id,
      story_points: "8"
    )

    @third_story = Story.create(
      name: "Story 3",
      description: "Story 3 us14",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/01/2017",
      final_date: "01/02/2017",
      issue_number: "10",
      sprint_id: @first_sprint.id,
      story_points: "3"
    )

    @another_first_story = Story.create(
      name: "Story 1",
      description: "Story 1 us13",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/02/2017",
      final_date: "01/03/2017",
      issue_number: "1",
      sprint_id: @second_sprint.id,
      story_points: "13"
    )

    @another_second_story = Story.create(
      name: "Story 1",
      description: "Story 1 us13",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/02/2017",
      final_date: "01/03/2017",
      issue_number: "2",
      sprint_id: @second_sprint.id,
      story_points: "5"
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "Should get burned sprint points" do
    final_date = @another_first_story.final_date

    burned_stories_test = {}
    burned_stories = {}

    burned_stories_test[final_date] =
                        @another_first_story.story_points +
                        @another_second_story.story_points


    assert_equal burned_stories_test, get_burned_points(@second_sprint, burned_stories)
  end

  test "Should set ideal axis" do
    date_axis_test = []
    ideal_line_test = []
    ideal_line = []

    planned_points = @another_first_story.story_points +
                     @another_second_story.story_points

    range_dates = (@another_first_story.initial_date .. @another_first_story.final_date)

    range_dates.each do |date|
      date_axis_test.push(date)
    end

    days_of_sprint = date_axis_test.length - 1

    for day in (days_of_sprint).downto(0)
      ideal_line_test.push(planned_points * (day / (Float days_of_sprint)))
    end

    set_ideal_line(days_of_sprint, ideal_line, planned_points)

    assert_equal ideal_line_test, ideal_line
  end
end
