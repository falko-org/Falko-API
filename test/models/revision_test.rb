require "test_helper"

class RevisionTest < ActiveSupport::TestCase
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
      initial_date: "23-04-1993",
      final_date: "23-04-2003",
      release_id: @release.id
    )

    @revision = Revision.create(
      done_report: ["A us11 foi feita com sucesso"],
      undone_report: ["Tudo foi feito"],
      sprint_id: @sprint.id
    )
  end

  test "should save a revision" do
    assert @revision.save
  end

  test "Revision should have done_report between 0 and 500 caracters" do
    @revision.done_report = ["r" * 250]
    assert @revision.save
  end

  test "Revision should have undone_report between 0 and 500 caracters" do
    @revision.undone_report = ["r" * 250]
    assert @revision.save
  end

  test "Revision should have done_report less than 500 caracters" do
    @revision.done_report = "b" * 501
    assert_not @revision.save
  end

  test "Revision should have undone_report less than 500 caracters" do
    @revision.undone_report = "b" * 501
    assert_not @revision.save
  end
end
