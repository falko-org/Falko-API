require "test_helper"

class RetrospectiveTest < ActiveSupport::TestCase
  def setup
    @user = User.create(
      name: "Ronaldo",
      email: "ronaldofenomeno@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "ronaldobola"
    )

    @project = Project.create(
      name: "Falko",
      description: "Esse projeto faz parte da disciplina MDS.",
      check_project: true,
      user_id: @user.id
    )

    @release = Release.create(
      name: "Release 1",
      description: "First Release.",
      initial_date: "01/01/2017",
      final_date: "02/02/2019",
      project_id: @project.id
    )

    @sprint = Sprint.create(
      name: "Sprint1",
      description: "Essa sprint",
      initial_date: "23/04/1993",
      final_date: "23/04/2003",
      release_id: @release.id
    )

    @retrospective = Retrospective.create(
      sprint_report: "Sprint description",
      positive_points: ["Very good"],
      negative_points: ["No tests"],
      improvements: ["Improve front-end"],
      sprint_id: @sprint.id
    )
  end

  test "should save a retrospective" do
    assert @retrospective.save
  end

  test "Restrospective should have sprint_report less than 1500 characters" do
    @retrospective.sprint_report = "a" * 1501
    assert_not @retrospective.save
  end

  test "Restrospective should have sprint_report 600 characters" do
    @retrospective.sprint_report = "a" * 600
    assert @retrospective.save
  end

  test "Restrospective should have positive_points less than 500 characters" do
    @retrospective.positive_points = "b" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have positive_points" do
    @retrospective.positive_points = ""
    assert_not @retrospective.save
  end

  test "Restrospective should have negative_points less than 500 characters" do
    @retrospective.negative_points = "c" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have negative_points" do
    @retrospective.negative_points = ""
    assert_not @retrospective.save
  end

  test "Restrospective should have improvements less than 500 characters" do
    @retrospective.improvements = "d" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have improvements" do
    @retrospective.improvements = ""
    assert_not @retrospective.save
  end
end
