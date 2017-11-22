require "test_helper"

class VelocityHelperTest < ActiveSupport::TestCase
  include VelocityHelper

  def setup
    @user = User.create(
      name: "Ronaldo",
      email: "Ronaldofenomeno@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "ronaldobola"
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
      story_points: '5'
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
      story_points: '8'
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
      story_points: '3'
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
      story_points: '13'
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
      story_points: '5'
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "should get correct sprints informations" do
    sprints = []
    sprints.push(@first_sprint)

    velocity = get_sprints_informations(sprints)

    total_points = @first_story.story_points +  @second_story.story_points + @third_story.story_points

    total_completed_points = @second_story.story_points + @third_story.story_points

    assert_equal [@first_sprint.name], velocity[:names]
    assert_equal [total_points], velocity[:total_points]
    assert_equal [total_completed_points], velocity[:completed_points]
    assert_equal [calculate_velocity([total_completed_points])], velocity[:velocities]
  end

  test "should calculate velocity" do
      sprint_1_points = @second_story.story_points +
                        @third_story.story_points

      sprint_2_points = @another_first_story.story_points +
                        @another_second_story.story_points

      completed_points = []
      completed_points.push(sprint_1_points)
      completed_points.push(sprint_2_points)

      velocity = Float(sprint_1_points + sprint_2_points)/2

      assert_equal velocity, calculate_velocity(completed_points)
  end

end
