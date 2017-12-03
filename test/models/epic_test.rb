require 'test_helper'

class EpicTest < ActiveSupport::TestCase
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
      is_scoring: false
    )

    @epic = Epic.create(
      title: "E1",
      description: "Description E1",
      project_id: @project.id
    )
  end

  test "should save valid epic" do
    assert @epic.save
  end

  test "should not save epic with a blank title" do
    @epic.title = ""
    assert_not @epic.save
  end

  test "should not save a epic with title smaller than 2 characters" do
    @epic.title = "M"
    assert_not @epic.save
  end

  test "should not save a epic with title bigger than 128 characters" do
    @epic.title = "a" * 129
    assert_not @epic.save
  end

  test "should save a epic with an exacty 2 or 80 characters title" do
    @epic.title = "Ma"
    assert @epic.save
    @epic.title = "a" * 80
    assert @epic.save
  end

  test "should save epic with a blank description" do
    @epic.description = ""
    assert @epic.save
  end

  test "should not save a epic with description bigger than 256 characters" do
    @epic.description = "a" * 257
    assert_not @epic.save
  end

  test "should save a epic with an exacty 256 characters description" do
    @epic.description = "a" * 256
    assert @epic.save
  end

  test "should save a epic with a blank description" do
    @epic.description = ""
    assert @epic.save
  end
end
