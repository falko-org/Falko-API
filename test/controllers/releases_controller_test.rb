require "test_helper"

class ReleasesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Robert", email: "robert@email.com",
                        password: "123123", password_confirmation: "123123",
                        github: "robertGit")
    @project = Project.create(name: "Falko", description: "Description.",
                              user_id: @user.id, is_project_from_github: true)
    @release = Release.create(name: "R1", description: "Description",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(name: "Ronaldo", email: "ronaldo@email.com",
                        password: "123123", password_confirmation: "123123",
                        github: "ronaldoGit")
    @another_project = Project.create(name: "Futebol", description: "Description.",
                              user_id: @user.id, is_project_from_github: true)
    @another_release = Release.create(name: "Real Madrid", description: "Descriptions",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create release" do
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name": "Release 01",
        "description": "First Release",
        "amount_of_sprints": "20",
        "initial_date": "2018-01-01",
        "final_date": "2019-01-01"
      }
    }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create release without correct params" do
    # Final date before initial date
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name": "Release 01",
        "description": "First Release",
        "amount_of_sprints": "20",
        "initial_date": "2018-01-01",
        "final_date": "1900-01-01"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end


  test "should not create release without authentication" do
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name": "Release 01",
        "description": "First Release",
        "amount_of_sprints": "20",
        "initial_date": "2018-01-01",
        "final_date": "2019-01-01"
      }
    }

    assert_response :unauthorized
  end

  test "should not get releases index without authentication" do
    get "/projects/#{@project.id}/releases"
    assert_response :unauthorized
  end

  test "should get releases index" do
    get "/projects/#{@project.id}/releases", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should not get releases show without authentication" do
    get "/releases/#{@release.id}"
    assert_response :unauthorized
  end

  test "should get releases show" do
    get "/releases/#{@release.id}", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should edit releases" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params: {
      release: {
        name: "Daniboy", description: "CBlacku", initial_date: "2010-05-06"
      }
    }, headers: { Authorization: @token.result }

    @release.reload

    assert_response :ok
    assert_not_equal @old_name_release, @release.name
    assert_not_equal @old_description_release, @release.description
    assert_not_equal @old_initial_date_release, @release.initial_date
  end

  test "should not edit releases without authenticantion" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params: {
      release: {
        name: "Daniboy", description: "CBlacku", initial_date: "2010-05-06"
      }
    }

    @release.reload

    assert_response :unauthorized
    assert_equal @old_name_release, @release.name
    assert_equal @old_description_release, @release.description
    assert_equal @old_initial_date_release, @release.initial_date
  end

  test "should not edit releases with blank params" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params: {
      release: {
        name: "", description: "", initial_date: ""
      }
    }, headers: { Authorization: @token.result }

    @release.reload

    assert_response :unprocessable_entity
    assert_equal @old_name_release, @release.name
    assert_equal @old_description_release, @release.description
    assert_equal @old_initial_date_release, @release.initial_date
  end

  test "should destroy release" do
    assert_difference("Release.count", -1) do
      delete "/releases/#{@release.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy release without authentication" do
    assert_no_difference "Release.count" do
      delete "/releases/#{@release.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy release of another user" do
    delete "/releases/#{@release.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end
end
