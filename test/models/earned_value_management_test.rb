require "test_helper"

class EarnedValueManagementTest < ActiveSupport::TestCase
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

    @release = Release.create(
      name: "Release 1",
      description: "First Release.",
      initial_date: "01/01/2017",
      final_date: "02/02/2019",
      project_id: @project.id
    )

    @evm = EarnedValueManagement.create(
      budget_actual_cost: "20",
       planned_release_points: "20",
      planned_sprints: "9",
      release_id: @release.id
    )
 end

  test "should save a valid evm" do
    assert @evm.save
  end

  test "should not save a evm without a release" do
    @evm.release_id = nil
    assert_not @evm.save
  end

  test "should not save evm with blank budget_actual_cost" do
    @evm.budget_actual_cost = ""
    assert_not @evm.save
  end

  test "should not save evm with blank planned_release_points" do
    @evm.planned_release_points = ""
    assert_not @evm.save
  end

  test "should not create evm with negative parameters" do
    @wrong_evm = EarnedValueManagement.create(
      budget_actual_cost: "-1",
      planned_release_points: "-1",
      planned_sprints: "30"
    )
    assert_not @wrong_evm.save
  end
end
