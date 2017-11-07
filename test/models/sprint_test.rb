require "test_helper"

class SprintTest < ActiveSupport::TestCase
  def setup
    @user = User.create(
      name: "Gilberto",
      email: "gilbertin@teste.com",
      password: "1234567",
      password_confirmation: "1234567",
      github: "gilbertoCoder"
    )

    @project = Project.create(
      name: "Falko",
      description: "Esse projeto faz parte da disciplina MDS.",
      is_project_from_github: true,
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
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "06/10/2017",
      final_date: "13/10/2017",
      release_id: @release.id
    )
  end

  test "should save a valid sprint" do
    assert @sprint.save
  end

  test "Sprint should have a name" do
    @sprint.name = ""
    assert_not @sprint.save
  end

  test "Sprint should have a start date" do
    @sprint.initial_date = ""
    assert_not @sprint.save
  end

  test "Sprint should have an end date" do
    @sprint.final_date = ""
    assert_not @sprint.save
  end

  test "Sprint name should have more than 1 characters" do
    @sprint.name = "s"
    assert_not @sprint.save
  end

  test "Sprint name should not have more than 128 characters" do
    @sprint.name = "a" * 129
    assert_not @sprint.save
  end

  test "Sprint name should have 2 characters" do
    @sprint.name = "ss"
    assert @sprint.save
  end

  test "Sprint name should have between 2 and 128 characters" do
    @sprint.name = "s" * 60
    assert @sprint.save
  end

  test "Sprint name should have 128 characters" do
    @sprint.name = "s" * 128
    assert @sprint.save
  end

  test "should not save a sprint with end date before start date" do
    @sprint.initial_date = "13/10/2017"
    @sprint.final_date = "06/10/2017"
    assert_not @sprint.save
  end
end
