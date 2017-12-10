require "test_helper"

class SprintsControllerTest < ActionDispatch::IntegrationTest
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
      is_scoring: true
    )

    @project_scoring_false = Project.create(
      name: "Falko",
      description: "Some project description.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: false
    )

    @release = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2017",
      final_date: "01/01/2020",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @release_scoring_false = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @project_scoring_false.id
    )

    @sprint = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "01/01/2017",
      final_date: "08/01/2017",
      release_id: @release.id
    )

    @sprint_scoring_false = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "06/10/2018",
      final_date: "13/10/2018",
      release_id: @release_scoring_false.id
    )

    @story = Story.create(
      name: "Story 1",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "In progress",
      initial_date: "01/01/2017",
      story_points: "10",
      sprint_id: @sprint.id
    )

    @story = Story.create(
      name: "Story 2",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/01/2017",
      final_date: "07/01/2017",
      story_points: "10",
      sprint_id: @sprint.id
    )


    @story = Story.create(
      name: "Story 3",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "Done",
      initial_date: "01/01/2017",
      final_date: "07/01/2017",
      story_points: "10",
      sprint_id: @sprint.id
    )

    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(
      name: "Ronaldo 2",
      email: "Ronaldofenomeno1@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "ronaldobola2"
    )

    @another_project = Project.create(
      name: "Falko 2",
      description: "Some project description 2.",
      user_id: @another_user.id,
      is_project_from_github: true
    )

    @another_release = Release.create(
      name: "R2",
      description: "Description",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "22",
      project_id: @another_project.id
    )

    @another_sprint = Sprint.create(
      name: "Sprint 2",
      description: "Sprint 2 us10",
      initial_date: "06/10/2018",
      final_date: "13/10/2018",
      release_id: @another_release.id
    )

    @project_without_score = Project.create(
      name: "Falko",
      description: "Some project description.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: false
    )

    @release_without_score = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2017",
      final_date: "01/01/2020",
      amount_of_sprints: "20",
      project_id: @project_without_score.id
    )

    @sprint_without_score = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "01/01/2017",
      final_date: "08/01/2017",
      release_id: @release_without_score.id
    )

    @story_without_score = Story.create(
      name: "Story 1",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "In progress",
      initial_date: "01/01/2017",
      sprint_id: @sprint_without_score.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end


  test "should create a sprint with valids params" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Sprint Name",
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not create a sprint with name size less than 2 characters" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "S",
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with name size bigger than 128 characters" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "S" * 129,
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with description size bigger then 256 characters" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Sprint",
        "description": "D" * 257,
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with start date after end date" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Sprint",
        "description": "Description of sprint",
        "initial_date": "13/10/2018",
        "final_date": "25/06/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should edit a sprint with valids params" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint 02",
        "description": "Description of sprint",
        "initial_date": "13/10/2018",
        "final_date": "17/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not edit a sprint with name size less than 2 characters" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "S",
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not edit a sprint with name size bigger than 128 characters" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "S" * 129,
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not edit a sprint with description size bigger then 256 characters" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint",
        "description": "D" * 257,
        "initial_date": "25/06/2018",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not edit a sprint that belong to another user" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint",
        "description": "Description of sprint",
        "initial_date": "13/10/2018",
        "final_date": "25/06/2018"
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not edit sprints with blank params" do
    @old_name_sprint = @sprint.name
    @old_description_sprint = @sprint.description
    @old_initial_date_sprint = @sprint.initial_date

    patch "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "",
        "description": "",
        "initial_date": ""
      }
    }, headers: { Authorization: @token.result }

    @sprint.reload

    assert_response :unprocessable_entity
    assert_equal @old_name_sprint, @sprint.name
    assert_equal @old_description_sprint, @sprint.description
    assert_equal @old_initial_date_sprint, @sprint.initial_date
  end

  test "should delete a sprint that belong to current user" do
    delete "/sprints/#{@sprint.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not delete a sprint that belong to another user" do
    delete "/sprints/#{@sprint.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should show a sprint information of current user" do
    get "/sprints/#{@sprint.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not show a sprint information that belong to another user" do
    get "/sprints/#{@sprint.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should list all sprints that belong to a release" do
    get "/releases/#{@release.id}/sprints", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "Should get Burndown data if project is scored" do
    get "/sprints/#{@sprint.id}/burndown", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "Should not get Burndown data if project is not scored" do
    get "/sprints/#{@sprint_without_score.id}/burndown", headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with a final date outside the release interval" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Sprint Name",
        "description": "Description of sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2060"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with a initial date outside the release interval" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Sprint Name",
        "description": "Description of sprint",
        "initial_date": "25/06/1990",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should get velocity data if project is scoring" do
    get "/sprints/#{@sprint.id}/velocity", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get velocity data if project is not scoring" do
    get "/sprints/#{@sprint_scoring_false.id}/velocity", headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
    assert response.parsed_body["error"] == "The Velocity is only available in projects that use Story Points"
  end

  test "should get velocity variance data if project is scoring" do
    get "/sprints/#{@sprint.id}/velocity_variance", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get velocity variance data if project is not scoring" do
    get "/sprints/#{@sprint_scoring_false.id}/velocity_variance", headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
    assert response.parsed_body["error"] == "The Velocity variance is only available in projects that use Story Points"
  end

  test "should get burndown variance data if project is scoring" do
    get "/sprints/#{@sprint.id}/burndown_variance", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get burndown variance data if project is not scoring" do
    get "/sprints/#{@sprint_scoring_false.id}/burndown_variance", headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
    assert response.parsed_body["error"] == "The Burndown variance is only available in projects that use Story Points"
  end

  test "should get debts from a project if it is scoring" do
    get "/sprints/#{@sprint.id}/debts", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get debts from a project if it is not scoring" do
    get "/sprints/#{@sprint_scoring_false.id}/debts", headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
    assert response.parsed_body["error"] == "Debts is only available in projects that use Story Points"
  end
end
