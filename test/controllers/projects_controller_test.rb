require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
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
      "github_slug": "alaxalves/Falko"
    )

    @project2 = Project.create(
      "name": "Falko",
      "description": "Some project description 2.",
      "user_id": @user.id,
      "is_project_from_github": false,
      "github_slug": "alaxalves/LabBancos"
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "should create project" do
      post "/users/#{@user.id}/projects", params: {
        "project": {
          "name": "Falko",
          "description": "Some project description.",
          "user_id": @user.id,
          "is_project_from_github": true
        }
      }, headers: { Authorization: @token.result }

      assert_response :created
    end

  test "should not create project with invalid parameters" do
      @old_count = Project.count

      post "/users/#{@user.id}/projects", params: {
        "project": {
          "name": "",
          "description": "A" * 260,
          "is_project_from_github": true
        }
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
      assert_equal @old_count, Project.count
    end

  test "should show project" do
    get "/projects/#{@project.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should update project" do
      @old_name = @project.name
      @old_description = @project.description

      patch "/projects/#{@project.id}", params: {
        project: {
          "name": "Falko BackEnd",
          "description": "Falko BackEnd!",
          "is_project_from_github": "true"
        }
      }, headers: { Authorization: @token.result }
      @project.reload

      assert_not_equal @old_name, @project.name
      assert_not_equal @old_description, @project.description
      assert_response :success
    end

  test "should not update project with invalid parameters" do
      @old_name = @project.name
      @old_description = @project.description

      patch "/projects/#{@project.id}", params: {
        project: {
          "name": "a",
          "description": "a",
          "is_project_from_github": "false"
        }
      }, headers: { Authorization: @token.result }
      @project.reload

      assert_response :unprocessable_entity
      assert_equal @old_name, @project.name
      assert_equal @old_description, @project.description
    end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete "/projects/#{@project.id}", headers: { Authorization: @token.result }
    end

    assert_response 204
  end

  test "should see repositories if user is loged in" do
    mock = Minitest::Mock.new

    def mock.user
      Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test")
    end

    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }
      assert response.parsed_body["user"] == [{ "login" => "test" }, { "repos" => ["test"] }]
      assert_response :success
    end
  end

  test "should not see repositories if user email is wrong" do
    @token = AuthenticateUser.call("wrongtest@test.com", @user.password)

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password is wrong" do
    @token = AuthenticateUser.call(@user.email, "wrongtest")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password and email are wrong" do
    @token = AuthenticateUser.call("wrongtest2@test.com", "wrongtest")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user token is wrong" do
    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: "hgfcjgcgfc" }

      assert_response :unauthorized
    end
  end

  test "should receive an numeric score" do
    @token = AuthenticateUser.call(@user.email, @user.password)
    codeclimate_response = '{
        "data": [{
            "id": "696a76232df2736347000001",
            "type": "repos",
            "attributes": {
              "analysis_version": 3385,
              "badge_token": "16096d266f46b7c68dd4",
              "branch": "master",
              "created_at": "2017-07-15T20:08:03.732Z",
              "github_slug": "twinpeaks\/ranchorosa",
              "human_name": "ranchorosa",
              "last_activity_at": "2017-07-15T20:09:41.846Z",
              "score": 2.92
            }
          }]
        }'

    RestClient.stub :get, codeclimate_response do
      get "/projects/#{@project.id}/gpa", headers: { Authorization: @token.result }
      assert_response :success
      assert response.parsed_body == 2.92
    end
  end

  test "should not import a project from github if the is_project_from_github is invalid" do
      post "/users/#{@user.id}/projects", params: {
        "project": {
          "name": "Falko",
          "description": "Some project description.",
          "user_id": @user.id
        }
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
    end
end
