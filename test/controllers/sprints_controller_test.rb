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
      is_scoring: false
    )

    @release = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @sprint = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "06/10/2018",
      final_date: "13/10/2018",
      release_id: @release.id
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

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end


  test "should create a sprint with valids params" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Saaaaa",
        "description": "Descrição da sprint",
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
        "description": "Descrição da sprint",
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
        "description": "Descrição da sprint",
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
        "description": "Descrição",
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
        "description": "Descrição de uma sprint",
        "initial_date": "13/10/2018",
        "final_date": "25/12/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not edit a sprint with name size less than 2 characters" do
    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "S",
        "description": "Descrição da sprint",
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
        "description": "Descrição da sprint",
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
        "description": "Descrição",
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

  test "should not create a sprint with a final date outside the release interval" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Saaaaa",
        "description": "Descrição da sprint",
        "initial_date": "25/06/2018",
        "final_date": "13/10/2060"
      }
    }, headers: { Authorization: @token.result }

    assert_response :not_acceptable
  end

  test "should not create a sprint with a initial date outside the release interval" do
    post "/releases/#{@release.id}/sprints", params: {
      "sprint": {
        "name": "Saaaaa",
        "description": "Descrição da sprint",
        "initial_date": "25/06/1990",
        "final_date": "13/10/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :not_acceptable
  end

end
