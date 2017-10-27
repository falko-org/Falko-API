require "test_helper"

class ReleaseTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Ronaldo", email: "Ronaldofenomeno@gmail.com",
                        password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @project = Project.create(name: "Falko", description: "Esse projeto faz parte da disciplina MDS.",
                              user_id: @user.id, check_project: true)
    @release = Release.create(name: "Release 1", description: "First Release.",
                              initial_date: "01/01/2017", final_date: "02/02/2019",
                              project_id: @project.id)
  end

  test "should save a valid release" do
    assert @release.save
  end

  test "should not save a release without a project" do
    @release.project_id = nil
    assert_not @release.save
  end

  test "should not save a release without name" do
    @release.name = ""
    assert_not @release.save
  end

  test "should with name smaller than 2 characters" do
    @release.name = "R"
    assert_not @release.save
  end

  test "should with name greater than 80 characters" do
    @release.name = "R" * 81
    assert_not @release.save
  end

  test "should not save a release with initial date after final date" do
    @release.initial_date = "01/01/2017"
    @release.final_date = "01/01/2016"
    assert_not @release.save
  end

  test "should not save a release without initial date" do
    @release.initial_date = ""
    assert_not @release.save
  end

  test "should not save a release without final date" do
    @release.final_date = ""
    assert_not @release.save
  end

  test "should not save a release with an invalid initial date" do
    @release.initial_date = "50/50/2000"
    assert_not @release.save
  end

  test "should not save a release with an invalid final date" do
    @release.final_date = "50/50/2000"
    assert_not @release.save
  end

  test "should save a release with a blank description" do
    @release.description = ""
    assert @release.save
  end

  test "should not save a release with description greater than 256 characters" do
    @release.description = "A" * 257
    assert_not @release.save
  end
end
