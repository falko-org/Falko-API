require 'test_helper'

class EpicsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      name: "Robert",
      email: "robert@email.com",
      password: "123123",
      password_confirmation: "123123",
      github: "robertGit"
    )

    @project = Project.create(
      name: "Falko",
      description: "Description.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: false
    )

    @epic = Epic.create(
      title: "E1",
      description: "Description E1",
      project_id: @project.id
    )

    @feature = Feature.create(
      title: "F1",
      description: "Description F1",
      epic_id: @epic.id
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

    @another_epic = Epic.create(
      title: "E1",
      description: "Description E1",
      project_id: @another_project.id
    )

    @another_feature = Feature.create(
      title: "F1",
      description: "Description F1",
      epic_id: @another_epic.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create epic" do
      post "/projects/#{@project.id}/epics", params: {
        "epic": {
          "title": "epic 01",
          "description": "First epic",
          "project_id":"#{@project.id}"
        }
      }, headers: { Authorization: @token.result }

      assert_response :created
    end

  test "should not create epic without correct title" do
    # Final date before initial date
    post "/projects/#{@project.id}/epics", params: {
      "epic": {
        "title": "E",
        "description": "First epic",
        "project_id":"#{@project.id}"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create epic without correct description" do
      # Final date before initial date
      post "/projects/#{@project.id}/epics", params: {
        "epic": {
          "title": "Epic 111",
          "description": "a" * 257,
          "project_id":"#{@project.id}"
        }
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
    end

  test "should not create epic without authentication" do
    post "/projects/#{@project.id}/epics", params: {
      "feature": {
        "title": "Feature 01",
        "description": "First Feature",
        "epic_id":"#{@project.id}"
      }
    }

    assert_response :unauthorized
  end

  test "should not get epic index without authentication" do
    get "/projects/#{@project.id}/epics"
    assert_response :unauthorized
  end

  test "should get epic index" do
    get "/projects/#{@project.id}/epics", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should not get epics show without authentication" do
    get "/epics/#{@epic.id}"
    assert_response :unauthorized
  end

  test "should get epic show" do
    get "/epics/#{@epic.id}", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should edit epics" do
      @old_title_epic = @epic.title
      @old_description_epic = @epic.description

      patch "/epics/#{@epic.id}", params: {
        epic: {
          title: "Daniboy",
          description: "CBlacku"
        }
      }, headers: { Authorization: @token.result }

      @epic.reload

      assert_response :ok
      assert_not_equal @old_title_epic, @epic.title
      assert_not_equal @old_description_epic, @epic.description
    end

  test "should not edit epic without authenticantion" do
    @old_title_epic = @epic.title
    @old_description_epic = @epic.description

    patch "/epics/#{@epic.id}", params: {
      epic: {
        title: "Daniboy",
        description: "CBlacku"
      }
    }

    @epic.reload

    assert_response :unauthorized
    assert_equal @old_title_epic, @epic.title
    assert_equal @old_description_epic, @epic.description
  end

  test "should not edit epic with blank title" do
      @old_title_epic = @epic.title
      @old_description_epic = @epic.description

      patch "/epics/#{@epic.id}", params: {
        epic: {
          title: "",
          description: ""
        }
      }, headers: { Authorization: @token.result }

      @epic.reload

      assert_response :unprocessable_entity
      assert_equal @old_title_epic, @epic.title
      assert_equal @old_description_epic, @epic.description
    end

  test "should destroy epic" do
    assert_difference("Epic.count", -1) do
      delete "/epics/#{@epic.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy epic without authentication" do
    assert_no_difference "Epic.count" do
      delete "/epics/#{@epic.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy epic of another user" do
    delete "/epics/#{@epic.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end
end
