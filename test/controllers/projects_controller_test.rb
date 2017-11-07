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
      "description": "Descrição do projeto.",
      "user_id": @user.id,
      "check_project": true
    )

    @project2 = Project.create(
      "name": "Falko",
      "description": "Descrição do projeto.",
      "user_id": @user.id,
      "check_project": false
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "should create project" do
    post "/users/#{@user.id}/projects", params: {
       "project": {
         "name": "Falko",
         "description": "Descrição do projeto.",
         "user_id": @user.id,
         "check_project": true
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
         "check_project": true
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
        "description": "Este é o BackEnd do Falko!",
        "check_project": "true"
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
        "check_project": "false"
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
      Sawyer::Resource.new(Sawyer::Agent.new("/teste"), login: "teste")
    end

    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste" }) ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { login: "teste" }) ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste1" }) ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }
      assert response.parsed_body["user"] == [{ "login"=>"teste" }, { "repos" => ["teste"] }]
      assert_response :success
    end
  end

  test "should not see repositories if user email is wrong" do
    @token = AuthenticateUser.call("testeerrado@teste.com", @user.password)

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste" }) ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { login: "teste" }) ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste1" }) ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password is wrong" do
    @token = AuthenticateUser.call(@user.email, "testeerrado")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste" }) ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { login: "teste" }) ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste1" }) ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password and email are wrong" do
    @token = AuthenticateUser.call("testeerrado2@teste.com", "testeerrado")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste" }) ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { login: "teste" }) ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste1" }) ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user token is wrong" do
    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste" }) ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { login: "teste" }) ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/teste"), { name: "teste1" }) ]
    end

    Octokit::Client.stub :new, mock do
      get "/repos", headers: { Authorization: "hgfcjgcgfc" }

      assert_response :unauthorized
    end
  end

  test "should not import a project from github if the check_project is invalid" do
    post "/users/#{@user.id}/projects", params: {
      "project": {
        "name": "Falko",
        "description": "Descrição do projeto.",
        "user_id": @user.id
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end
end
