require 'test_helper'

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
  
  # test "should show evm" do
  #   get "/releases/#{@release.id}/earned_value_management", headers: { Authorization: @token.result }

  #   assert_response :success
  # end


end
