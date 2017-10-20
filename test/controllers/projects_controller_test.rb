require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Ronaldo", email: "Ronaldofenomeno@gmail.com", password: "123456789", password_confirmation: "123456789", github: "ronaldobola")
    @project = Project.create(name: "Falko", description: "Descrição do projeto.", user_id: @user.id)
  end

  # test "should get index" do
  #   @token = AuthenticateUser.call(@user.email, @user.password)
  #
  #   get "/users/#{@user.id}/projects", headers: {:Authorization => @token.result}
  #
  #   assert_response :success
  # end

  test "should create project" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    post "/users/#{@user.id}/projects", params: {
       "project": {
         "name": "Falko",
         "description": "Descrição do projeto.",
         "user_id": "@user.id"
       }
     }, headers: { Authorization: @token.result }

    assert_response :created
  end

  test "should not create project with invalid parameters" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    @old_count = Project.count

    post "/users/#{@user.id}/projects", params: {
       "project": {
         "name": "",
         "description": "A" * 260
       }
     }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
    assert_equal @old_count, Project.count
  end

  test "should show project" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    get project_url(@project), as: :json, headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should get edit" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    get project_url(@project), as: :json, headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should update project" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    @old_name = @project.name
    @old_description = @project.description

    patch project_url(@project), params: { project: { name: "Falko BackEnd", description: "Este é o BackEnd do Falko!" } }, as: :json, headers: { Authorization: @token.result }
    @project.reload

    assert_not_equal @old_name, @project.name
    assert_not_equal @old_description, @project.description
    assert_response :success
  end

  test "should not update project with invalid parameters" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    @old_name = @project.name
    @old_description = @project.description

    patch project_url(@project), params: { project: { name: "Falko", description: "a" * 260 } }, as: :json, headers: { Authorization: @token.result }
    @project.reload

    assert_response :unprocessable_entity
    assert_equal @old_name, @project.name
    assert_equal @old_description, @project.description
  end

  test "should destroy project" do
    @token = AuthenticateUser.call(@user.email, @user.password)

    assert_difference("Project.count", -1) do
      delete project_url(@project), as: :json, headers: { Authorization: @token.result }
    end

    assert_response 204
  end
end
