require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @project = Project.create(name: "Falko", description: "Descrição do projeto.")
  end

  test "should get index" do
    get projects_url, as: :json

    assert_response :success
  end

  test "should get new" do
    get projects_url, as: :json

    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_url, params: { project: { name: "Falko", description: "Descrição do projeto." } }, as: :json
    end

    assert_response :created
  end

  test "should not create project with invalid parameters" do
    @old_count = Project.count

    post projects_url, params: { project: { name: "", description: "A" * 260 } }, as: :json

    assert_response :unprocessable_entity
    assert_equal @old_count, Project.count
  end

  test "should show project" do
    get project_url(@project), as: :json

    assert_response :success
  end

  test "should get edit" do
    get project_url(@project), as: :json

    assert_response :success
  end

  test "should update project" do
    @old_name = @project.name
    @old_description = @project.description

    patch project_url(@project), params: { project: { name: "Falko BackEnd", description: "Este é o BackEnd do Falko!" } }, as: :json
    @project.reload

    assert_not_equal @old_name, @project.name
    assert_not_equal @old_description, @project.description
    assert_response :success
  end

  test "should not update project with invalid parameters" do
    @old_name = @project.name
    @old_description = @project.description

    patch project_url(@project), params: { project: { name: "Falko", description: "a" * 260 } }, as: :json
    @project.reload

    assert_response :unprocessable_entity
    assert_equal @old_name, @project.name
    assert_equal @old_description, @project.description
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete project_url(@project), as: :json
    end

    assert_response 204
  end
end
