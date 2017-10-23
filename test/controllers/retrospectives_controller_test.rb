require 'test_helper'

class RetrospectivesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @another_user = User.create(name: 'Felipe', email: 'Felipe@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'felipe')
    @another_project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @another_user.id)
    @another_sprint = Sprint.create(name: "Sprint1", description: "Essa sprint", project_id: @another_project.id, start_date: "23-04-1993", end_date: "23-04-2003")
    @another_retrospective = Retrospective.create(sprint_report: "Sprint descricao", positive_points: "muito boa", negative_points: "Horrivel", improvements: "Melhorar visual", sprint_id: @another_sprint.id)
    @another_token = AuthenticateUser.call(@another_user.email, @another_user.password)

    @user = User.create(name: 'Ronaldo', email: 'Ronaldofenomeno@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'ronaldobola')
    @project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user.id)
    @sprint = Sprint.create(name: "Sprint1", description: "Essa sprint", project_id: @project.id, start_date: "23-04-1993", end_date: "23-04-2003")
    @retrospective = Retrospective.create(sprint_report: "Sprint descricao", positive_points: "muito boa", negative_points: "Horrivel", improvements: "Melhorar visual", sprint_id: @sprint.id)
    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "Should create a Retrospective" do
    post "/sprints/#{@sprint.id}/retrospectives", params: {
       "retrospective":{
         "sprint_report":"Descricao Retro",
         "positive_points":"Bom demais",
         "negative_points":"Ruim demais",
         "improvements":"Tem que melhorar"
       }
     }, headers: {:Authorization => @token.result}

     assert_response :created
  end

  test "Should not create a Retrospective without authentication" do
    post "/sprints/#{@sprint.id}/retrospectives", params: {
       "retrospective":{
         "sprint_report":"Descricao Retro",
         "positive_points":"Bom demais",
         "negative_points":"Ruim demais",
         "improvements":"Tem que melhorar"
       }
     }

     assert_response :unauthorized
  end

  test "Should get retrospective show" do
    get "/retrospectives/#{@retrospective.id}", headers: {:Authorization => @token.result}
    assert_response :success
  end

  test "Should not get retrospective show without authentication" do
    get "/retrospectives/#{@retrospective.id}"
    assert_response :unauthorized
  end

  test "Should edit retrospective" do
    @old_sprint_report = @retrospective.sprint_report
    @old_positive_points = @retrospective.positive_points
    @old_negative_points = @retrospective.negative_points
    @old_improvements = @retrospective.improvements

    patch "/retrospectives/#{@retrospective.id}", params: {
      retrospective: {
        sprint_report: "muda", positive_points: "muda", negative_points: "muda",
        improvements: "muda"
      }
    }, headers: {:Authorization => @token.result}

    @retrospective.reload

    assert_response :ok
    assert_not_equal @old_sprint_report, @retrospective.sprint_report
    assert_not_equal @old_positive_points, @retrospective.positive_points
    assert_not_equal @old_negative_points, @retrospective.negative_points
    assert_not_equal @improvements, @retrospective.improvements
  end

  test "Should not edit retrospective without authentication" do
    @old_sprint_report = @retrospective.sprint_report
    @old_positive_points = @retrospective.positive_points
    @old_negative_points = @retrospective.negative_points
    @old_improvements = @retrospective.improvements

    patch "/retrospectives/#{@retrospective.id}", params: {
      retrospective: {
        sprint_report: "muda", positive_points: "muda", negative_points: "muda",
        improvements: "muda"

      }
    }

    @retrospective.reload

    assert_response :unauthorized
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
