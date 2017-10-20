require 'test_helper'

class RetrospectiveTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: 'Ronaldo', email: 'Ronaldofenomeno@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'ronaldobola')
    @project = Project.create(name: "Falko", description: "Esse projeto faz parte da disciplina MDS.", user_id: @user.id)
    @sprint = Sprint.create(name: "Sprint1", description: "Essa sprint", project_id: @project.id, start_date: "23-04-1993", end_date: "23-04-2003")
    @retrospective = Retrospective.create(sprint_report: "Sprint descricao", positive_points: "muito boa", negative_points: "Horrivel", improvements: "Melhorar visual", sprint_id: @sprint.id)
  end

  test "should save a retrospective" do
    assert @retrospective.save
  end

  test "Restrospective should have sprint_report less than 1500" do
    @retrospective.sprint_report = "a" * 1501
    assert_not @retrospective.save
  end

  test "Restrospective should have sprint_report between 0 and 1500" do
    @retrospective.sprint_report = ""
    assert @retrospective.save
  end

  test "Restrospective should have positive_points less than 500" do
    @retrospective.positive_points = "b" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have positive_points between 0 and 500" do
    @retrospective.positive_points = ""
    assert @retrospective.save
  end

  test "Restrospective should have negative_points less than 500" do
    @retrospective.negative_points = "c" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have negative_points between 0 and 500" do
    @retrospective.negative_points = ""
    assert @retrospective.save
  end

  test "Restrospective should have improvements less than 500" do
    @retrospective.improvements = "d" * 501
    assert_not @retrospective.save
  end

  test "Restrospective should have improvements between 0 and 500" do
    @retrospective.improvements = ""
    assert @retrospective.save
  end
end
