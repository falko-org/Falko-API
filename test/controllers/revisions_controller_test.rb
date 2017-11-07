require "test_helper"

class RevisionsControllerTest < ActionDispatch::IntegrationTest
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
      description: "Deion.",
      user_id: @user.id,
      check_project: true
    )

    @release = Release.create(
      name: "R1",
      description: "Deion",
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
    @no_revision_sprint = Sprint.create(
      name: "Sprint 2",
      description: "A Sprint",
      initial_date: "23-04-1993",
      final_date: "23-04-2003",
      release_id: @release.id
    )

    @revision = Revision.create(
      done_report: ["Foi feito a historia us14"],
      undone_report: ["Não foi feito a historia us22"],
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
      description: "Deion.",
      user_id: @user.id,
      check_project: true
    )

    @another_release = Release.create(
      name: "Real Madrid",
      description: "Deions",
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

    @another_revision = Revision.create(
      done_report: ["Não foi feito nada"],
      undone_report: ["Tudo"],
      sprint_id: @sprint.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create a Revision" do
    post "/sprints/#{@no_revision_sprint.id}/revisions", params: {
      "revision": {
        "done_report": ["US16"],
        "undone_report": ["US17", "US28"]
      }
     }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create multiple revisions" do
  post "/sprints/#{@sprint.id}/revisions", params: {
     "revision": {
       "done_report": ["US16"],
       "undone_report": ["US17", "US28"]
     }
   }, headers: { Authorization: @token.result }

  assert_response :forbidden
end

  test "should not create revision without correct params" do
    post "/sprints/#{@no_revision_sprint.id}/revisions", params: {
      "revision": {
        "done_report": "US14" * 500,
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end


  test "should not create revision without authentication" do
    post "/sprints/#{@sprint.id}/revisions", params: {
      "revision": {
        "done_report": ["US16"],
        "undone_report": ["US17", "US28"]
      }
    }

    assert_response :unauthorized
  end

  test "should not create revision in another user" do
    post "/sprints/#{@sprint.id}/revisions", params: {
      "revision": {
        "done_report": ["US16"],
        "undone_report": ["US17", "US28"]
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not get revisions index without authentication" do
    get "/sprints/#{@sprint.id}/revisions"

    assert_response :unauthorized
  end

  test "should get revisions index" do
    get "/sprints/#{@sprint.id}/revisions", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get revisions of other user" do
    get "/sprints/#{@sprint.id}/revisions", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not get revisions show without authentication" do
    get "/revisions/#{@revision.id}"

    assert_response :unauthorized
  end

  test "should get revisions show" do
    get "/revisions/#{@revision.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get revisions show of another user" do
    get "/revisions/#{@revision.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should edit revisions" do
    @old_done_report = @revision.done_report
    @old_undone_report = @revision.undone_report

    patch "/revisions/#{@revision.id}", params: {
      revision: {
        done_report: ["US05"],
        undone_report: ["US03", "us14"]
      }
    }, headers: { Authorization: @token.result }

    @revision.reload

    assert_response :ok
    assert_not_equal @old_done_report, @revision.done_report
    assert_not_equal @old_undone_report, @revision.undone_report
  end

  test "should not edit revision without authentication" do
    @old_done_report = @revision.done_report
    @old_undone_report = @revision.undone_report

    patch "/revisions/#{@revision.id}", params: {
      revision: {
        done_report: ["US05"],
        undone_report: ["US03", "us14"]
      }
    }

    @revision.reload

    assert_response :unauthorized
    assert_equal @old_done_report, @revision.done_report
    assert_equal @old_undone_report, @revision.undone_report
  end

  test "should not edit revision with wrong params" do
    @old_done_report = @revision.done_report
    @old_undone_report = @revision.undone_report

    patch "/revisions/#{@revision.id}", params: {
      revision: {
        done_report: [ "a"] * 1501,
      }
    }, headers: { Authorization: @token.result }

    @revision.reload

    assert_response :unprocessable_entity
    assert_equal @old_done_report, @revision.done_report
    assert_equal @old_undone_report, @revision.undone_report
  end

  # test "should not edit revision with blank params" do
  #   @old_done_report = @revision.done_report
  #   @old_undone_report = @revision.undone_report
  #
  #   patch "/revisions/#{@revision.id}", params: {
  #     revision: {
  #       done_report: ""
  #     }
  #   }, headers: { Authorization: @token.result }
  #
  #   @revision.reload
  #
  #   assert_response :unprocessable_entity
  #   assert_equal @old_done_report, @revision.done_report
  #   assert_equal @old_undone_report, @revision.undone_report
  # end

  test "should not edit revisions of another user" do
    patch "/revisions/#{@revision.id}", params: {
      revision: {
        done_report: ["US05"],
        undone_report: ["US03", "us14"]
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should destroy revision" do
    assert_difference("Revision.count", -1) do
      delete "/revisions/#{@revision.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy revision without authentication" do
    assert_no_difference "Revision.count" do
      delete "/revisions/#{@revision.id}"
    end

    assert_response :unauthorized
  end

  test "should not destroy revision of another user" do
    delete "/revisions/#{@revision.id}", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end
end
