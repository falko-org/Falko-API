require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
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
      check_project: true
    )

    @release = Release.create(
      name: "R1",
      description: "Description",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @sprint = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "06/10/2017",
      final_date: "13/10/2017",
      release_id: @release.id
    )

    @story = Story.create(
      name: "Story 1",
      description: "Story 1 us14",
      assign: "Lucas",
      pipeline: "In Progress",
      initial_date: "01/01/2017",
      sprint_id: @sprint.id
    )

    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(
      name: "Ronaldo",
      email: "ronaldo@email.com",
      password: "123123",
      password_confirmation: "123123",
      github: "ronaldoGit"
    )

    @another_project = Project.create(
      name: "Futebol",
      description: "Description.",
      user_id: @user.id,
      check_project: true
    )

    @another_release = Release.create(
      name: "Real Madrid",
      description: "Descriptions",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @another_sprint = Sprint.create(
      name: "Sprint 2",
      description: "Sprint 2 us10",
      initial_date: "06/10/2017",
      final_date: "13/10/2017",
      release_id: @release.id
    )

    @another_story = Story.create(
      name: "Story 2",
      description: "Story 2 us14",
      assign: "Alax",
      pipeline: "Done",
      initial_date: "01/01/2017",
      final_date: "07/01/2017",
      sprint_id: @sprint.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create story" do
    post "/sprints/#{@sprint.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "Done",
        "initial_date": "01/01/2018",
        "final_date": "09/01/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create story without correct params" do
    # Final date before initial date
    post "/sprints/#{@sprint.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "a" * 60,
        "initial_date": "01/01/2018"
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end


  test "should not create story without authentication" do
    post "/sprints/#{@sprint.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "In Progress",
        "initial_date": "01/01/2018"
      }
    }

    assert_response :unauthorized
  end

  test "should not create story in another user" do
    post "/sprints/#{@sprint.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "In Progress",
        "initial_date": "01/01/2018"
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not create story with invalid dates" do
    post "/sprints/#{@sprint.id}/stories", params: {
      "story": {
        "name": "Story 01",
        "description": "First Story",
        "assign": "Mateus",
        "pipeline": "Done",
        "initial_date": "2018-01-02",
        "final_date": "01/01/2018"
      }
    }

    assert_response :unauthorized
  end

  test "should not get stories index without authentication" do
    get "/sprints/#{@sprint.id}/stories"

    assert_response :unauthorized
  end

  test "should get stories index" do
    get "/sprints/#{@sprint.id}/stories", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get stories of other user" do
    get "/sprints/#{@sprint.id}/stories", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not get stories show without authentication" do
    get "/stories/#{@story.id}"

    assert_response :unauthorized
  end

  test "should get stories show" do
    get "/stories/#{@story.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should get stories show of other user" do
    get "/stories/#{@story.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should update stories" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date
    @old_assign_story = @story.assign
    @old_pipeline_story = @story.pipeline

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "Story 5",
        description: "Story 3 us14",
        assign: "Richard",
        pipeline: "Done",
        initial_date: "02/01/2017",
        final_date: "09/01/2017"
      }
    }, headers: { Authorization: @token.result }

    @story.reload

    assert_response :ok
    assert_not_equal @old_name_story, @story.name
    assert_not_equal @old_description_story, @story.description
    assert_not_equal @old_initial_date_story, @story.initial_date
    assert_not_equal @old_assign_story, @story.assign
    assert_not_equal @old_pipeline_story, @story.pipeline
  end

  test "should not update stories without authenticantion" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date
    @old_assign_story = @story.assign
    @old_pipeline_story = @story.pipeline

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "Story 6",
        description: "Story 3 us14",
        assign: "Richard",
        pipeline: "Backlog",
        initial_date: "01/01/2017"
      }
    }

    @story.reload

    assert_response :unauthorized
    assert_equal @old_name_story, @story.name
    assert_equal @old_description_story, @story.description
    assert_equal @old_initial_date_story, @story.initial_date
    assert_equal @old_assign_story, @story.assign
    assert_equal @old_pipeline_story, @story.pipeline
  end

  test "should not update stories with blank params" do
    @old_name_story = @story.name
    @old_description_story = @story.description
    @old_initial_date_story = @story.initial_date
    @old_assign_story = @story.assign
    @old_pipeline_story = @story.pipeline

    patch "/stories/#{@story.id}", params: {
      story: {
        name: "",
        description: "",
        assign: "",
        pipeline: "",
        initial_date: ""
      }
    }, headers: { Authorization: @token.result }

    @story.reload

    assert_response :unprocessable_entity
    assert_equal @old_name_story, @story.name
    assert_equal @old_description_story, @story.description
    assert_equal @old_initial_date_story, @story.initial_date
    assert_equal @old_assign_story, @story.assign
    assert_equal @old_pipeline_story, @story.pipeline
  end

  test "should not update stories of another user" do
    patch "/stories/#{@story.id}", params: {
      story: {
        name: "Story 6",
        description: "Story 3 us14",
        assign: "Richard",
        pipeline: "Backlog",
        initial_date: "01/01/2017"
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
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
