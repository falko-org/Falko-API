require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Ronaldo", email: "Ronaldofenomeno@gmail.com", password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @token = AuthenticateUser.call(@user.email, @user.password)
    @project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user.id, is_project_from_github: true)
    @project2 = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user.id, is_project_from_github: false)
  end

  test "should see issues if user is loged in" do

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

  test "should not see issues if user is not loged in" do

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

  test "should create issues if user is loged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.create_issue(path, name, body, options)
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), title: name, body: body, number: "3")
    end


    Octokit::Client.stub :new, mock do
      post "/projects/#{@project.id}/issues", headers: { Authorization: @token.result }, params: {
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

  test "should not create issues if user is not loged in" do

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

  test "should update issues if user is loged in" do

    mock = Minitest::Mock.new

    def mock.user()
      Sawyer::Resource.new(Sawyer::Agent.new("/issues_test"), login: "username_test")
    end

    def mock.update_issue(path, number, name, body, options)
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

  test "should not update issues if user is not loged in" do

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

  test "should close issue if user is loged in" do

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

  test "should not close issue if user is not loged in" do

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
end
