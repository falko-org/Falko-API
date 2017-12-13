require "test_helper"

class EarnedValueManagementControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      "name": "Ronaldo",
      "email": "ronaldofenomeno@gmail.com",
      "password": "123456789",
      "password_confirmation": "123456789",
      "github": "ronaldobola"
    )

    @project = Project.create(
      "name": "Falko",
      "description": "Some project description 1.",
      "user_id": @user.id,
      "is_project_from_github": true,
      "github_slug": "alaxalves/Falko",
      "is_scoring": false
    )
    @release = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "2018-01-01",
      final_date: "2019-01-01",
      amount_of_sprints: "20",
      project_id: @project.id
   )
    @evm = EarnedValueManagement.create(
      budget_actual_cost: "20",
      planned_release_points: "20",
      planned_sprints: "9",
      release_id: @release.id
      )

    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(name: "Ronaldo",
      email: "ronaldo@email.com",
      password: "123123",
      password_confirmation: "123123",
      github: "ronaldoGit"
    )

    @another_project = Project.create(
      name: "Futebol",
      description: "Description.",
      user_id: @another_user.id,
      is_project_from_github: true
    )

    @another_release = Release.create(
      name: "Real Madrid",
      description: "Descriptions",
      initial_date: "2020-01-01",
      final_date: "2021-01-01",
      amount_of_sprints: "20",
      project_id: @another_project.id
    )
    @another_evm = EarnedValueManagement.create(
      budget_actual_cost: "30",
      planned_release_points: "180",
     planned_sprints: "12",
     release_id: @another_release.id
    )
    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create evm" do
    post "/releases/#{@release.id}/earned_value_management", params: {
       "earned_value_management": {
         "budget_actual_cost": "20",
         "planned_release_points": "120",
         "planned_sprints": "9",
       }
     }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create evm without corrects params" do
   post "/releases/#{@release.id}/earned_value_management", params: {
     "earned_value_management": {
       "budget_actual_cost": "10",
       "planned_release_points": "-100",
       "planned_sprints": "9",
     }
   }, headers: { Authorization: @token.result }

   assert_response :unprocessable_entity
 end

  test "should not create evm without authentication" do
    post "/releases/#{@release.id}/earned_value_management", params: {
      "earned_value_management": {
       "budget_actual_cost": "2",
       "planned_release_points": "300",
       "planned_sprints": "10",
      }
    }

    assert_response :unauthorized
  end

  test "should show evm" do
    get "/earned_value_management/#{@evm.id}", headers: { Authorization: @token.result }

    assert_equal @evm.budget_actual_cost, response.parsed_body["budget_actual_cost"]
    assert_equal @evm.planned_sprints, response.parsed_body["planned_sprints"]
    assert_equal @evm.planned_release_points, response.parsed_body["planned_release_points"]
    assert_response :success
  end

  test "should not show nonexistent evm" do
    get "/earned_value_management/9999", headers: { Authorization: @token.result }

    assert_response :not_found
  end

  test "should update evm" do
    @old_budget_actual_cost = @evm.budget_actual_cost
    @old_planned_release_points = @evm.planned_release_points

    patch "/earned_value_management/#{@evm.id}", params: {
      "earned_value_management": {
        "budget_actual_cost": "30",
        "planned_release_points": "200",
        "planned_sprints": "1",
      }
    }, headers: { Authorization: @token.result }
    @evm.reload

    assert_not_equal @old_budget_actual_cost, @evm.budget_actual_cost
    assert_not_equal @old_planned_release_points, @evm.planned_release_points
    assert_response :success
  end

  test "should not update evm with invalid parameters" do
    @old_budget_actual_cost = @evm.budget_actual_cost
    @old_planned_release_points = @evm.planned_release_points

    patch "/earned_value_management/#{@evm.id}", params: {
      earned_value_management: {
        "budget_actual_cost": "a",
        "planned_release_points": "-30",
        "planned_sprints": "3"
      }
    }, headers: { Authorization: @token.result }
    @evm.reload

    assert_equal @old_budget_actual_cost, @evm.budget_actual_cost
    assert_equal @old_planned_release_points, @evm.planned_release_points
    assert_response :unprocessable_entity
  end
  test "should not update evm with blank parameters" do
    @old_budget_actual_cost = @evm.budget_actual_cost
    @old_planned_release_points = @evm.planned_release_points

    patch "/earned_value_management/#{@evm.id}", params: {
      earned_value_management: {
        "budget_actual_cost": "",
        "planned_release_points": "",
        "planned_sprints": ""
      }
    }, headers: { Authorization: @token.result }
    @evm.reload

    assert_equal @old_budget_actual_cost, @evm.budget_actual_cost
    assert_equal @old_planned_release_points, @evm.planned_release_points
  end

  test "should destroy evm" do
    assert_difference("EarnedValueManagement.count", -1) do
      delete "/earned_value_management/#{@evm.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy evm without authentication" do
    assert_no_difference "EarnedValueManagement.count" do
      delete "/earned_value_management/#{@evm.id}"
    end

    assert_response :unauthorized
  end

  # test "should not destroy evm with different user" do
  #   delete "/earned_value_management/#{@evm.id}", headers: { Authorization: @another_token.result }

  #   assert_response :unauthorized
  # end
end
