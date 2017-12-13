require "test_helper"

class GradeTest < ActiveSupport::TestCase
  def setup
    @user = User.create(
      name: "Ronaldo",
      email: "Ronaldofenomeno@gmail.com",
      password: "123456789",
      password_confirmation: "123456789"
    )

    @project = Project.create(
      name: "Falko",
      description: "This project is part of the course MDS.",
      is_project_from_github: true,
      user_id: @user.id,
      is_scoring: false
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
      description: "This sprint.",
      initial_date: "23-04-1993",
      final_date: "23-04-2003",
      release_id: @release.id
    )

    @grade = Grade.create(
      weight_debts: "1",
      weight_burndown: "1",
      weight_velocity: "1",
      project_id: @project.id
    )

    @grade = Grade.create(
      weight_debts: "1",
      weight_burndown: "1",
      weight_velocity: "1",
      project_id: @project.id
    )
  end

  test "should save a grade" do
    assert @grade.save
  end

  test "Grade should have a weight debts" do
    @grade.weight_debts = nil
    assert_not @grade.save
  end

  test "Grade should have a weight burndown" do
    @grade.weight_burndown = nil
    assert_not @grade.save
  end

  test "Grade should have a weight velocity" do
    @grade.weight_velocity = nil
    assert_not @grade.save
  end
end
