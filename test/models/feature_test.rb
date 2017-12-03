require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
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
    
    @feature = Feature.create(
      title: "F1",
      description: "Description F1",
      epic_id: @epic.id
    )
  end

  test "should save valid feature" do
    assert @feature.save
  end

  test "should not save feature with a blank title" do
    @feature.title = ""
    assert_not @feature.save
  end

  test "should not save a feature with title smaller than 2 characters" do
    @feature.title = "M"
    assert_not @feature.save
  end

  test "should not save a feature with title bigger than 128 characters" do
    @feature.title = "a" * 129
    assert_not @feature.save
  end

  test "should save a feature with an exacty 2 or 80 characters title" do
    @feature.title = "Ma"
    assert @feature.save
    @feature.title = "a" * 80
    assert @feature.save
  end

  test "should save feature with a blank description" do
    @feature.description = ""
    assert @feature.save
  end

  test "should not save a feature with description bigger than 256 characters" do
    @feature.description = "a" * 257
    assert_not @feature.save
  end

  test "should save a feature with an exacty 256 characters description" do
    @feature.description = "a" * 256
    assert @feature.save
  end

  test "should save a feature with a blank description" do
    @feature.description = ""
    assert @feature.save
  end
end
