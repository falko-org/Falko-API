require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
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
      description: "Project description.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: false
    )

    @another_project = Project.create(
      name: "FalkoSolutions/Falko",
      description: "Project description.",
      user_id: @user.id,
      is_project_from_github: false,
      is_scoring: false
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "should show issues if user is logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.list_issues(name)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: "issue", number: "3", body: "This is a template body") ]
    end


    Octokit::Client.stub :new, mock do
      get "/projects/#{@project.id}/issues", headers: { Authorization: @token.result }

      assert response.parsed_body["issues_infos"][0]["name"] == "issue"
      assert response.parsed_body["issues_infos"][0]["number"] == "3"
      assert response.parsed_body["issues_infos"][0]["body"] == "This is a template body"
      assert_response :success
    end
  end

  test "should not show issues if user is not logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.list_issues(name)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: "issue", number: "3", body: "This is a template body") ]
    end


    Octokit::Client.stub :new, mock do
      get "/projects/#{@project.id}/issues"

      assert_response :unauthorized
    end
  end

  test "should create issues if user is logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.create_issue(path, name, body)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: name, body: body, number: "3")
    end


    Octokit::Client.stub :new, mock do
      post "/projects/#{@another_project.id}/issues", headers: { Authorization: @token.result }, params: {
        issue: {
          "name": "New Issue",
          "body": "New Body"
        }
      }

      assert response.parsed_body["issues_infos"][0]["name"] == "New Issue"
      assert response.parsed_body["issues_infos"][0]["body"] == "New Body"
      assert_response :created
    end
  end

  test "should not create issues if user is not logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.create_issue(path, name, body, options)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: name, body: body, number: "3")
    end


    Octokit::Client.stub :new, mock do
      post "/projects/#{@project.id}/issues", params: {
        issue: {
          "name": "New Issue",
          "body": "New Body"
        }
      }

      assert_response :unauthorized
    end
  end

  test "should update issues if user is logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.update_issue(path, number, name, body)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: name, body: body, number: "3")
    end


    Octokit::Client.stub :new, mock do
      put "/projects/#{@project.id}/issues", headers: { Authorization: @token.result }, params: {
        issue: {
          "number": "3",
          "name": "Updated Issue",
          "body": "Updated Body"
        }
      }
      assert response.parsed_body["issues_infos"][0]["name"] == "Updated Issue"
      assert response.parsed_body["issues_infos"][0]["body"] == "Updated Body"
      assert_response :success
    end
  end

  test "should not update issues if user is not logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.update_issue(path, number, name, body, options)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: name, body: body, number: "3")
    end


    Octokit::Client.stub :new, mock do
      put "/projects/#{@project.id}/issues", params: {
        issue: {
          "number": "3",
          "name": "Updated Issue",
          "body": "Updated Body"
        }
      }

      assert_response :unauthorized
    end
  end

  test "should close issue if user is logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.close_issue(path, number)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), number: "3")
    end


    Octokit::Client.stub :new, mock do
      delete "/projects/#{@project.id}/issues", headers: { Authorization: @token.result }, params: {
        issue: {
          "number": "3"
        }
      }

      assert_response :success
    end
  end

  test "should not close issue if user is not logged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.close_issue(path, number)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), number: "3")
    end


    Octokit::Client.stub :new, mock do
      delete "/projects/#{@project.id}/issues", params: {
        issue: {
          "number": "3"
        }
      }

      assert_response :unauthorized
    end
  end

  test "should update issue assignees" do
    mock = Minitest::Mock.new
    def mock.code
      200
    end

    RestClient.stub :patch, mock do
      post "/projects/#{@project.id}/issues/assignees", params: {
        issue_number: "1",
        assignees: ["MatheusRich"]
      }, headers: { Authorization: @token.result }

      assert_response :ok
    end
  end

  test "should not update issue assignees" do
    mock = -> (path, payload, header) { raise RestClient::UnprocessableEntity }

    RestClient.stub :patch, mock do
      post "/projects/#{@project.id}/issues/assignees", params: {
        issue_number: "1",
        assignees: ["ThisUserIsNotOnTheRepo"]
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
    end
  end

  test "should not update issue assignees of an inexistent issue" do
    mock = -> (path, payload, header) { raise RestClient::NotFound }

    RestClient.stub :patch, mock do
      post "/projects/#{@project.id}/issues/assignees", params: {
        issue_number: "-1",
        assignees: ["MatheusRich"]
      }, headers: { Authorization: @token.result }

      assert_response :not_found
    end
  end

  test "should not update issue assignees without project" do
    post "/projects/-1/issues/assignees", params: {
      issue_number: "1",
      assignees: ["MatheusRich"]
    }, headers: { Authorization: @token.result }

    assert_response :not_found
  end

  test "should not show issues in Backlog already allocated" do
    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.list_issues(name)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: "issue", number: 9, body: "This is a template body") ]
    end


    Octokit::Client.stub :new, mock do
      get "/projects/#{@project.id}/issues", headers: { Authorization: @token.result }

      assert response.parsed_body["issues_infos"] == []
      assert_response :success
    end
  end
end
