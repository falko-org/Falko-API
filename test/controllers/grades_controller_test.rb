require "test_helper"

class GradeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      name: "Robert",
      email: "robert@email.com",
      password: "123123",
      password_confirmation: "123123"
    )

    @project = Project.create(
      name: "Falko",
      description: "Deion.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: false,
    )

    @release = Release.create(
      name: "R1",
      description: "Deion",
      initial_date: "01/01/2018",
      final_date: "01/03/2018",
      amount_of_sprints: "20",
      project_id: @project.id
    )

    @sprint = Sprint.create(
      name: "Sprint 1",
      description: "Sprint 1 us10",
      initial_date: "02/01/2018",
      final_date: "02/02/2018",
      release_id: @release.id
    )
    @no_grade_project = Project.create(
      name: "Falko",
      description: "Deion.",
      user_id: @user.id,
      is_project_from_github: true,
      is_scoring: true
    )

    @grade = Grade.create(
      weight_debts: "1",
      weight_burndown: "1",
      weight_velocity: "1",
      project_id: @project.id
    )

    @token = AuthenticateUser.call(@user.email, @user.password)

    @another_user = User.create(
      name: "Ronaldo",
      email: "ronaldo@email.com",
      password: "123123",
      password_confirmation: "123123"
    )

    @another_project = Project.create(
      name: "Futebol",
      description: "Deion.",
      user_id: @another_user.id,
      is_project_from_github: true
    )

    @has_grade_project = Project.create(
      name: "Futebol",
      description: "Deion.",
      user_id: @another_user.id,
      is_project_from_github: true
    )


    @another_release = Release.create(
      name: "Real Madrid",
      description: "Deions",
      initial_date: "01/01/2018",
      final_date: "01/01/2019",
      amount_of_sprints: "20",
      project_id: @another_project.id
    )

    @another_sprint = Sprint.create(
      name: "Sprint 2",
      description: "Sprint 2 us10",
      initial_date: "06/10/2018",
      final_date: "13/10/2018",
      release_id: @another_release.id
    )

    @another_grade = Grade.create(
      weight_debts: "1",
      weight_burndown: "2",
      weight_velocity: "3",
      project_id: @project.id
    )

    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)
  end

  test "should create a Grade" do
    post "/projects/#{@no_grade_project.id}/grades", params: {
      "grade": {
        "weight_debts": "1",
        "weight_velocity": "1",
        "weight_burndown": "1"
      }
     }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create multiple grades" do
    @old_weight_debts = @grade.weight_debts
    @old_weight_burndown = @grade.weight_burndown
    @old_weight_velocity = @grade.weight_velocity
    post "/projects/#{@project.id}/grades", params: {
     "grade": {
       "weight_debts": "2",
       "weight_velocity": "2",
       "weight_burndown": "2"
     }
     }, headers: { Authorization: @token.result }

    assert_equal @old_weight_debts, @grade.weight_debts
    assert_equal @old_weight_burndown, @grade.weight_burndown
    assert_equal @old_weight_velocity, @grade.weight_velocity
    assert_response :ok
  end

  test "should not create grade without correct params" do
    post "/projects/#{@no_grade_project.id}/grades", params: {
      "grade": {
        "weight_debts": "1",
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end


  test "should not create grade without authentication" do
    post "/projects/#{@project.id}/grades", params: {
      "grade": {
        "weight_debts": "1",
        "weight_velocity": "1",
        "weight_burndown": "1"
      }
    }

    assert_response :unauthorized
  end

  test "should not create grade in another user" do
    post "/projects/#{@project.id}/grades", params: {
      "grade": {
        "weight_debts": "1",
        "weight_velocity": "1",
        "weight_burndown": "1"
      }
    }, headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not get grades index without authentication" do
    get "/projects/#{@project.id}/grades"

    assert_response :unauthorized
  end

  test "should get grades index" do
    get "/projects/#{@project.id}/grades", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not get grades of other user" do
    get "/projects/#{@project.id}/grades", headers: { Authorization: @another_token.result }

    assert_response :unauthorized
  end

  test "should not get grades show without authentication" do
    get "/grades/#{@grade.id}"

    assert_response :unauthorized
  end

  # test "should get grades show" do
  #   get "/grades/#{@grade.id}", headers: { Authorization: @token.result }
  #
  #   assert_response :success
  # end
  #
  # test "should not get grades show of another user" do
  #   get "/grades/#{@grade.id}", headers: { Authorization: @another_token.result }
  #
  #   assert_response :unauthorized
  # end
  #
  # test "should edit grades" do
  #   @old_weight_debts = @grade.weight_debts
  #   @old_weight_burndown = @grade.weight_burndown
  #   @old_weight_velocity = @grade.weight_velocity
  #
  #   patch "/grades/#{@grade.id}", params: {
  #     grade: {
  #       weight_debts: "3",
  #       weight_burndown: "3",
  #       weight_velocity: "3",
  #     }
  #   }, headers: { Authorization: @token.result }
  #
  #   @grade.reload
  #
  #   assert_response :ok
  #   assert_not_equal @old_weight_debts, @grade.weight_debts
  #   assert_not_equal @old_weight_burndown, @grade.weight_burndown
  #   assert_not_equal @old_weight_velocity, @grade.weight_velocity
  # end
  #
  # test "should not edit grade without authentication" do
  #   @old_weight_debts = @grade.weight_debts
  #   @old_weight_burndown = @grade.weight_burndown
  #   @old_weight_velocity = @grade.weight_velocity
  #
  #   patch "/grades/#{@grade.id}", params: {
  #     grade: {
  #       weight_debts: "3",
  #       weight_burndown: "3",
  #       weight_velocity: "3",
  #     }
  #   }
  #
  #   @grade.reload
  #
  #   assert_response :unauthorized
  #   assert_not_equal @old_weight_debts, @grade.weight_debts
  #   assert_not_equal @old_weight_burndown, @grade.weight_burndown
  #   assert_not_equal @old_weight_velocity, @grade.weight_velocity
  # end
  #
  # test "should not edit grade with wrong params" do
  #   @old_weight_debts = @grade.weight_debts
  #
  #   patch "/grades/#{@grade.id}", params: {
  #     grade: {
  #       weight_debts: "1",
  #     }
  #   }, headers: { Authorization: @token.result }
  #
  #   @grade.reload
  #
  #   assert_response :unprocessable_entity
  #   assert_equal @old_weight_debts, @grade.weight_debts
  # end

  # test "should not edit grade with blank params" do
  #   @old_weight_debts = @grade.weight_debts
  #   @old_weight_debts = @grade.weight_debts
  #
  #   patch "/grades/#{@grade.id}", params: {
  #     grade: {
  #       weight_debts: ""
  #     }
  #   }, headers: { Authorization: @token.result }
  #
  #   @grade.reload
  #
  #   assert_response :unprocessable_entity
  #   assert_equal @old_weight_debts, @grade.weight_debts
  #   assert_equal @old_weight_debts, @grade.weight_debts
  # end

  # test "should not edit grades of another user" do
  #   patch "/grades/#{@grade.id}", params: {
  #     grade: {
  #       weight_debts: "3",
  #       weight_burndown: "3",
  #       weight_velocity: "3",
  #     }
  #   }, headers: { Authorization: @another_token.result }
  #
  #   assert_response :unauthorized
  # end

  test "should destroy grade" do
    assert_difference("Grade.count", -1) do
      delete "/grades/#{@grade.id}", headers: { Authorization: @token.result }
    end

    assert_response :no_content
  end

  test "should not destroy grade without authentication" do
    assert_no_difference "Grade.count" do
      delete "/grades/#{@grade.id}"
    end

    assert_response :unauthorized
  end

end
