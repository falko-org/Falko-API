require "test_helper"

class SprintsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Ronaldo", email: "Ronaldofenomeno@gmail.com", password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user.id)
    @sprint = Sprint.create(name: "Sprint 1", description: "Sprint 1 us10", start_date: "06/10/2017", end_date: "13/10/2017", project_id: @project.id)

    @user2 = User.create(name: "Ronaldo", email: "Ronaldofenomeno1@gmail.com", password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @project2 = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user2.id)
    @sprint2 = Sprint.create(name: "Sprint 1", description: "Sprint 1 us10", start_date: "06/10/2017", end_date: "13/10/2017", project_id: @project2.id)

    @token = AuthenticateUser.call(@user.email, @user.password)
    @token2 = AuthenticateUser.call(@user2.email, @user2.password)
  end


  test "should create a sprint with valids params" do

      post "/projects/#{@project.id}/sprints", params: {
        "sprint": {
          "name": "Sprint 1",
          "description": "Descrição da sprint",
          "start_date": "25/06/1996",
          "end_date": "13/10/2017"
        }
      }, headers: { Authorization: @token.result }

      assert_response :success
    end

  test "should not create a sprint with name size less than 2 characters" do

    post "/projects/#{@project.id}/sprints", params: {
      "sprint": {
        "name": "S",
        "description": "Descrição da sprint",
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create a sprint with name size bigger than 128 characters" do

    post "/projects/#{@project.id}/sprints", params: {
      "sprint": {
        "name": "S" * 129,
        "description": "Descrição da sprint",
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should not create a sprint with description size bigger then 256 characters" do

    post "/projects/#{@project.id}/sprints", params: {
      "sprint": {
        "name": "Sprint",
        "description": "D" * 257,
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should not create a sprint with start date after end date" do

    post "/projects/#{@project.id}/sprints", params: {
      "sprint": {
        "name": "Sprint",
        "description": "Descrição",
        "start_date": "13/10/2017",
        "end_date": "25/06/1996"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should edit a sprint with valids params" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint 02",
        "description": "Descrição de uma sprint",
        "start_date": "13/10/2017",
        "end_date": "25/12/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :success

  end

  test "should not edit a sprint with name size less than 2 characters" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "S",
        "description": "Descrição da sprint",
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not edit a sprint with name size bigger than 128 characters" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "S" * 129,
        "description": "Descrição da sprint",
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should not edit a sprint with description size bigger then 256 characters" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint",
        "description": "D" * 257,
        "start_date": "25/06/1996",
        "end_date": "13/10/2017"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should not edit a sprint with start date after end date" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint",
        "description": "Descrição",
        "start_date": "13/10/2017",
        "end_date": "25/06/1996"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity

  end

  test "should not edit a sprint that belong to another user" do

    put "/sprints/#{@sprint.id}", params: {
      "sprint": {
        "name": "Sprint",
        "description": "Descrição",
        "start_date": "13/10/2017",
        "end_date": "25/06/1996"
      }
    }, headers: { Authorization: @token2.result }

    assert_response :unauthorized

  end

  test "should delete a sprint that belong to current user" do

    delete "/sprints/#{@sprint.id}", headers: { Authorization: @token.result }

    assert_response :success

  end

  test "should not delete a sprint that belong to another user" do

    delete "/sprints/#{@sprint2.id}", headers: { Authorization: @token.result }

    assert_response :unauthorized

  end

  test "should show a sprint information of current user" do

    get "/sprints/#{@sprint.id}", headers: { Authorization: @token.result }

    assert_response :success

  end

  test "should not show a sprint information that belong to another user" do

    get "/sprints/#{@sprint2.id}", headers: { Authorization: @token.result }

    assert_response :unauthorized

  end

  test "should list all sprints that belong to a project" do

    get "/projects/#{@project.id}/sprints", headers: { Authorization: @token.result }

    assert_response :success

  end
end
