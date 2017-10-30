require "test_helper"

class StoryTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Gilberto", email: "gilbertin@teste.com", password: "1234567", password_confirmation: "1234567", github: "gilbertoCoder")

    @project = Project.create(name: "Falko", description: "Esse projeto faz parte da disciplina MDS.", user_id: @user.id, check_project: true)

    @release = Release.create(name: "Release 1", description: "First Release.", initial_date: "01/01/2017", final_date: "02/02/2019", project_id: @project.id)

    @sprint = Sprint.create(name: "Sprint 1", description: "Sprint 1 us10", initial_date: "06/10/2017", final_date: "13/10/2017", release_id: @release.id)

    @story = Story.create(name: "Story 1", description: "Story 1 us14", assign: "Lucas", pipeline: "in progress", initial_date: "01/01/2017", sprint_id: @sprint.id)

  end

  test "should save a valid story" do
    assert @story.save
  end

  test "Story should have a name" do
    @story.name = ""
    assert_not @story.save
  end

  test "Story should have a start date" do
    @story.initial_date = ""
    assert_not @story.save
  end

  test "Story name should have more than 1 characters" do
    @story.name = "s"
    assert_not @story.save
  end

  test "Story name should not have more than 128 characters" do
    @story.name = "a" * 129
    assert_not @story.save
  end

  test "The number of characters in story name is between 2 and 128" do
    @story.name = "ss"
    assert @story.save

    @story.name = "s" * 60
    assert @story.save

    @story.name = "s" * 128
    assert @story.save
  end

  test "Story assign should have more than 1 characters" do
    @story.assign = "s"
    assert_not @story.save
  end

  test "Story name should not have more than 32 characters" do
    @story.assign = "a" * 33
    assert_not @story.save
  end

  test "The number of characters in story assign is between 2 and 32" do
    @story.assign = "ss"
    assert @story.save

    @story.assign = "s" * 16
    assert @story.save

    @story.assign = "s" * 32
    assert @story.save
  end

  test "Story pipeline should have more than 3 characters" do
    @story.pipeline = "s"
    assert_not @story.save
  end

  test "Story name should not have more than 16 characters" do
    @story.pipeline = "a" * 17
    assert_not @story.save
  end

  test "The number of characters in story pipeline is between 4 and 16" do
    @story.pipeline = "ssss"
    assert @story.save

    @story.pipeline = "s" * 5
    assert @story.save

    @story.pipeline = "s" * 16
    assert @story.save
  end


end
