require "test_helper"

class FeaturesControllerTest < ActionDispatch::IntegrationTest
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

    @feature = Feature.create(
      title: "F1",
      description: "Description F1",
      project_id: @project.id
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

    @another_feature = Feature.create(
      title: "Paris Saint German",
      description: "Descriptions",
      project_id: @another_project.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create feature" do
      post "/projects/#{@project.id}/features", params: {
        "feature": {
          "title": "Feature 01",
          "description": "First Feature"
        }
      }, headers: { Authorization: @token.result }

      assert_response :created
    end

  test "should not create feature without correct title" do
    # Final date before initial date
    post "/projects/#{@project.id}/features", params: {
      "feature": {
        "title": "F",
        "description": "First Feature"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should not create feature without correct description" do
      # Final date before initial date
      post "/projects/#{@project.id}/features", params: {
        "feature": {
          "title": "Feature 111",
          "description": "a" * 257
        }
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
    end

  test "should not create feature without authentication" do
    post "/projects/#{@project.id}/features", params: {
      "feature": {
        "title": "Feature 01",
        "description": "First Feature"
      }
    }

    assert_response :unauthorized
  end

  test "should not get features index without authentication" do
    get "/projects/#{@project.id}/features"
    assert_response :unauthorized
  end

  test "should get features index" do
    get "/projects/#{@project.id}/features", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should not get features show without authentication" do
    get "/features/#{@feature.id}"
    assert_response :unauthorized
  end

  test "should get features show" do
    get "/features/#{@feature.id}", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should edit features" do
      @old_title_feature = @feature.title
      @old_description_feature = @feature.description

      patch "/features/#{@feature.id}", params: {
        feature: {
          title: "Daniboy",
          description: "CBlacku"
        }
      }, headers: { Authorization: @token.result }

      @feature.reload

      assert_response :ok
      assert_not_equal @old_title_feature, @feature.title
      assert_not_equal @old_description_feature, @feature.description
    end

  test "should not edit features without authenticantion" do
    @old_title_feature = @feature.title
    @old_description_feature = @feature.description

    patch "/features/#{@feature.id}", params: {
      feature: {
        title: "Daniboy",
        description: "CBlacku"
      }
    }

    @feature.reload

    assert_response :unauthorized
    assert_equal @old_title_feature, @feature.title
    assert_equal @old_description_feature, @feature.description
  end

  test "should not edit features with blank title" do
      @old_title_feature = @feature.title
      @old_description_feature = @feature.description

      patch "/features/#{@feature.id}", params: {
        feature: {
          title: "",
          description: ""
        }
      }, headers: { Authorization: @token.result }

      @feature.reload

      assert_response :unprocessable_entity
      assert_equal @old_title_feature, @feature.title
      assert_equal @old_description_feature, @feature.description
    end

  test "should destroy feature" do
    assert_difference("Feature.count", -1) do
      delete "/features/#{@feature.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy feature without authentication" do
    assert_no_difference "Feature.count" do
      delete "/features/#{@feature.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy feature of another user" do
    delete "/features/#{@feature.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end
end
