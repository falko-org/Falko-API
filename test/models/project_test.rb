require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    @project = Project.create(name: "Falko", description: "Esse projeto faz parte da disciplina MDS.")
  end

  test "should save valid project" do
    assert @project.save
  end

  test "should not save project with a blank name" do
    @project.name = ""
    assert_not @project.save
  end

  test "should not save a project with name smaller than 2 characters" do
    @project.name = "M"
    assert_not @project.save
  end

  test "should not save a project with name bigger than 128 characters" do
    @project.name = "a" * 129
    assert_not @project.save
  end

  test "should save a project with an exacty 2 or 128 characters name" do
    @project.name = "Ma"
    assert @project.save
    @project.name = "a" * 128
    assert @project.save
  end

  test "should save project with a blank description" do
    @project.description = ""
    assert @project.save
  end

  test "should not save a project with description bigger than 256 characters" do
    @project.description = "a" * 257
    assert_not @project.save
  end

  test "should save a project with an exacty 5 or 256 characters description" do
    @project.description = "Maria"
    assert @project.save
    @project.description = "a" * 256
    assert @project.save
  end

end
