require "test_helper"

class RetrospectivesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Ronaldo", email: "Ronaldofenomeno@gmail.com", password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @project = Project.create(name: "Falko", description: "A Project.", user_id: @user.id)
    @sprint = Sprint.create(name: "Sprint 1", description: "A Sprint", project_id: @project.id,
                            start_date: "23-04-1993", end_date: "23-04-2003")
    @no_retrospective_sprint = Sprint.create(name: "Sprint 2", description: "A Sprint", project_id: @project.id,
                            start_date: "23-04-1993", end_date: "23-04-2003")
    @retrospective = Retrospective.create(sprint_report: "This sprint was very good",
                                          positive_points: ["positive point"],
                                          negative_points: ["negative point"],
                                          improvements: ["improvement"],
                                          sprint_id: @sprint.id)
    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(name: "Felipe", email: "Felipe@gmail.com", password: "123456789", password_confirmation: "123456789", github: "felipe")
    @another_project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @another_user.id)
    @another_sprint = Sprint.create(name: "Sprint1", description: "Essa sprint", project_id: @another_project.id, start_date: "23-04-1993", end_date: "23-04-2003")
    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create a Retrospective" do
    post "/sprints/#{@no_retrospective_sprint.id}/retrospectives", params: {
       "retrospective": {
         "sprint_report": "Description",
         "positive_points": ["None", "none"],
         "negative_points": ["none"],
         "improvements": ["improvements"]
       }
     }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create multiple retrospective" do
    post "/sprints/#{@sprint.id}/retrospectives", params: {
       "retrospective": {
         "sprint_report": "Description",
         "positive_points": ["None", "none"],
         "negative_points": ["none"],
         "improvements": ["improvements"]
       }
     }, headers: { Authorization: @token.result }

    assert_response :forbidden
  end

  test "should not create a Retrospective without authentication" do
    post "/sprints/#{@no_retrospective_sprint.id}/retrospectives", params: {
       "retrospective": {
         "sprint_report": "Description",
         "positive_points": ["None", "none"],
         "negative_points": ["none"],
         "improvements": ["improvements"]
       }
     }

    assert_response :unauthorized
  end

  test "should get retrospective show" do
    get "/retrospectives/#{@retrospective.id}", headers: { Authorization: @token.result }
    assert_response :success
  end
  
  test "should not get retrospective show without authentication" do
    get "/retrospectives/#{@retrospective.id}"
    assert_response :unauthorized
  end

  test "should not see another user's retrospective" do
    get "/retrospectives/#{@retrospective.id}", headers: { Authorization: @another_token.result }
    assert_response :unauthorized
  end

  test "should get retrospective index" do
    get "/sprints/#{@sprint.id}/retrospectives", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should not get retrospective index without authentication" do
    get "/sprints/#{@sprint.id}/retrospectives"
    assert_response :unauthorized
  end

  test "should edit retrospective" do
    @old_sprint_report = @retrospective.sprint_report
    @old_positive_points = @retrospective.positive_points
    @old_negative_points = @retrospective.negative_points
    @old_improvements = @retrospective.improvements

    patch "/retrospectives/#{@retrospective.id}", params: {
      retrospective: {
        sprint_report: "changed",
        positive_points: ["changed"],
        negative_points: ["changed"],
        improvements: ["changed"]
      }
    }, headers: { Authorization: @token.result }

    @retrospective.reload

    assert_response :ok
    assert_not_equal @old_sprint_report, @retrospective.sprint_report
    assert_not_equal @old_positive_points, @retrospective.positive_points
    assert_not_equal @old_negative_points, @retrospective.negative_points
    assert_not_equal @improvements, @retrospective.improvements
  end

  test "should not edit retrospective without authentication" do
    @old_sprint_report = @retrospective.sprint_report
    @old_positive_points = @retrospective.positive_points
    @old_negative_points = @retrospective.negative_points
    @old_improvements = @retrospective.improvements

    patch "/retrospectives/#{@retrospective.id}", params: {
      retrospective: {
        sprint_report: "changed",
        positive_points: ["changed"],
        negative_points: ["changed"],
        improvements: ["changed"]

      }
    }

    @retrospective.reload

    assert_response :unauthorized
    assert_equal @old_sprint_report, @retrospective.sprint_report
    assert_equal @old_positive_points, @retrospective.positive_points
    assert_equal @old_negative_points, @retrospective.negative_points
    assert_equal @old_improvements, @retrospective.improvements
  end

  test "should not edit retrospective with wrong params" do
    @old_sprint_report = @retrospective.sprint_report
    @old_positive_points = @retrospective.positive_points
    @old_negative_points = @retrospective.negative_points
    @old_improvements = @retrospective.improvements

    patch "/retrospectives/#{@retrospective.id}", params: {
      retrospective: {
        sprint_report: "a"*1501,
      }
    }, headers: { Authorization: @token.result }

    @retrospective.reload

    assert_response :unprocessable_entity
    assert_equal @old_sprint_report, @retrospective.sprint_report
    assert_equal @old_positive_points, @retrospective.positive_points
    assert_equal @old_negative_points, @retrospective.negative_points
    assert_equal @old_improvements, @retrospective.improvements
  end

  test "should destroy retrospective" do
      assert_difference("Retrospective.count", -1) do
        delete "/retrospectives/#{@retrospective.id}", headers: { Authorization: @token.result }
      end

      assert_response :no_content
    end

  test "should not destroy retrospective without authentication" do
    assert_no_difference "Retrospective.count" do
      delete "/retrospectives/#{@retrospective.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy retrospective of another user" do
    assert_no_difference "Retrospective.count" do
      delete "/retrospectives/#{@retrospective.id}", headers: { Authorization: @another_token.result }
    end

    assert_response :unauthorized
  end
end
