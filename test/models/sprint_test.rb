require "test_helper"

class SprintTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Gilberto", email: "gilbertin@teste.com", password: "1234567", password_confirmation: "1234567", github: "gilbertoCoder")

    @project = Project.create(name: "Falko", description: "Esse projeto faz parte da disciplina MDS.", user_id: @user.id)

    @sprint = Sprint.create(name: "Sprint 1", description: "Sprint 1 us10", start_date: "06/10/2017", end_date: "13/10/2017", project_id: @project.id)
  end

  test "should save a valid sprint" do
    assert @sprint.save
  end

  test "Sprint should have a name" do
    @sprint.name = ""
    assert_not @sprint.save
  end

  test "Sprint should have a start date" do
    @sprint.start_date = ""
    assert_not @sprint.save
  end

  test "Sprint should have an end date" do
    @sprint.end_date = ""
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

  test "The number of characters in sprint name is between 2 and 128" do
    @sprint.name = "ss"
    assert @sprint.save

    @sprint.name = "s" * 60
    assert @sprint.save

    @sprint.name = "s" * 128
    assert @sprint.save
  end

  test "should not save a sprint with end date before start date" do
    @sprint.start_date = "13/10/2017"
    @sprint.end_date = "06/10/2017"
    assert_not @sprint.save
  end
end
