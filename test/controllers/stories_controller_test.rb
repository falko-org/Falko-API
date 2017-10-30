require "test_helper"

class ReleasesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Robert", email: "robert@email.com",
                        password: "123123", password_confirmation: "123123",
                        github: "robertGit")
    @project = Project.create(name: "Falko", description: "Description.",
                              user_id: @user.id, check_project: true)
    @release = Release.create(name: "R1", description: "Description",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @sprint = Sprint.create(name: "Sprint 1", description: "Sprint 1 us10", initial_date: "06/10/2017", final_date: "13/10/2017", release_id: @release.id)
    @story = Story.create(name: "Story 1", description: "Story 1 us14", assign: "Lucas", pipeline: "in progress", initial_date: "01/01/2017", sprint_id: @sprint.id)

    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(name: "Ronaldo", email: "ronaldo@email.com",
                        password: "123123", password_confirmation: "123123",
                        github: "ronaldoGit")
    @another_project = Project.create(name: "Futebol", description: "Description.",
                              user_id: @user.id, check_project: true)
    @another_release = Release.create(name: "Real Madrid", description: "Descriptions",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @another_sprint = Sprint.create(name: "Sprint 2", description: "Sprint 2 us10", initial_date: "06/10/2017", final_date: "13/10/2017", release_id: @release.id)
    @another_story = Story.create(name: "Story 2", description: "Story 2 us14", assign: "Alax", pipeline: "done", initial_date: "01/01/2017", sprint_id: @sprint.id)
    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create story" do
    post "/releases/#{@release.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "Done",
        "initial_date": "2018-01-01"
      }
    }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create story without correct params" do
    # Final date before initial date
    post "/releases/#{@release.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "Doneeeesasdasdfadfjhgfdjglfdhgojlhroutlrjgoiskfdlhg",
        "initial_date": "2018-01-01"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end


  test "should not create story without authentication" do
    post "/releases/#{@release.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "Done",
        "initial_date": "2018-01-01"
      }
    }

    assert_response :unauthorized
  end

  test "should not get stories index without authentication" do
    get "/releases/#{@release.id}/stories"
    assert_response :unauthorized
  end

  test "should get stories index" do
    get "/releases/#{@release.id}/stories", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should not get stories show without authentication" do
    get "/stories/#{@story.id}"
    assert_response :unauthorized
  end

  test "should get stories show" do
    get "/stories/#{@story.id}", headers: { Authorization: @token.result }
    assert_response :success
  end

  test "should edit stories" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "Story 5", description: "Story 3 us14", assign: "Richard", pipeline: "Done", initial_date: "01/01/2017"
      }
    }, headers: { Authorization: @token.result }

    @story.reload

    assert_response :ok
    assert_not_equal @old_name_story, @story.name
    assert_not_equal @old_description_story, @story.description
    assert_not_equal @old_initial_date_story, @story.initial_date
  end

  test "should not edit stories without authenticantion" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "Story 6", description: "Story 3 us14", assign: "Richard", pipeline: "Done", initial_date: "01/01/2017"
      }
    }

    @story.reload

    assert_response :unauthorized
    assert_equal @old_name_story, @story.name
    assert_equal @old_description_story, @story.description
    assert_equal @old_initial_date_story, @story.initial_date
  end

  test "should not edit stories with blank params" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "", description: "", assign: "", pipeline: "", initial_date: ""
      }
    }, headers: { Authorization: @token.result }

    @story.reload

    assert_response :unprocessable_entity
    assert_equal @old_name_story, @story.name
    assert_equal @old_description_story, @story.description
    assert_equal @old_initial_date_story, @story.initial_date
  end

  test "should destroy story" do
    assert_difference("Story.count", -1) do
      delete "/stories/#{@story.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy story without authentication" do
    assert_no_difference "Story.count" do
      delete "/stories/#{@story.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy story of another user" do
    delete "/stories/#{@story.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end
end
