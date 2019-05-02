require "rest-client"

class ProjectsController < ApplicationController
  include ValidationsHelper

  before_action :set_project, only: [:destroy, :show, :get_contributors]

  before_action only: [:index, :create] do
    validate_user(0, :user_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_project(:id, 0)
  end

  def_param_group :project do
    param :name, String, "Project's name"
    param :description, String, "Project's description"
    param :created_at, Date, "Project's time of creation", allow_nil: false
    param :updated_at, Date, "Project's time of edition", allow_nil: false
    param :user_id, :number, "User's id of project's owner"
    param :is_project_from_github, :boolean, "Verify if project is from a github account"
    param :is_scoring, :boolean, "Verify if project counts story points"
  end

  api :GET, "/users/:user_id/projects", "Show projects for an user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all projects of a specific user"
  returns code: 200, desc: "Ok" do
    param_group :project
  end
  example <<-EOS
  [
    {
      "id":1,
      "name":"Owla",
      "description":"This project helps improving classes",
      "created_at":"2019-04-11T15:42:34.013Z",
      "updated_at":"2019-04-11T15:42:34.013Z",
      "user_id":1,
      "github_slug":null,
      "is_project_from_github":true,
      "is_scoring":true
    },
    {
      "id":2,
      "name":"Falko",
      "description":"This project helps agile projects",
      "created_at":"2019-04-11T15:42:34.044Z",
      "updated_at":"2019-04-11T15:42:34.044Z",
      "user_id":1,
      "github_slug":null,
      "is_project_from_github":true,
      "is_scoring":true
    }
  ]
  EOS
  def index
    @projects = User.find(params[:user_id]).projects
    render json: @projects
  end

  api :GET, "/repos", "Show a github projects list"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a projects list of current user from github"
  def github_projects_list
    client = Adapter::GitHubProject.new(request)

    user_login = client.get_github_user

    @form_params_user = { user: [] }
    @form_params_user[:user].push(login: user_login)

    user_repos = []

    (client.get_github_repos(user_login)).each do |repo|
      user_repos.push(repo.name)
    end

    @form_params_user[:user].push(repos: user_repos)

    @form_params_orgs = { orgs: [] }

    (client.get_github_orgs(user_login)).each do |org|
      repos_names = []
      (client.get_github_orgs_repos(org)).each do |repo|
        repos_names.push(repo.name)
      end
      @form_params_orgs[:orgs].push(name: org.login, repos: repos_names)
    end

    @form_params_user_orgs = @form_params_orgs.merge(@form_params_user)

    render json: @form_params_user_orgs
  end

  api :GET, "/projects/:id", "Show a specific project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  returns code: 200, desc: "Ok" do
    param_group :project
  end
  example <<-EOS
  {
    "id":1,
    "name":"Owla",
    "description":"This project helps improving classes",
    "created_at":"2019-04-11T15:42:34.013Z",
    "updated_at":"2019-04-11T15:42:34.013Z",
    "user_id":1,
    "github_slug":null,
    "is_project_from_github":true,
    "is_scoring":true
  }
  EOS
  def show
    render json: @project
  end

  api :POST, "/users/:user_id/projects", "Create a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create project for a specific user"
  param_group :project
  def create
    @project = Project.create(project_params)
    @project.user_id = @current_user.id

    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "/projects/:id", "Update a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update project for a specific user"
  param_group :project
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/projects/:id", "Delete a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete project for a specific user"
  param_group :project
  def destroy
    @project.destroy
  end

  def get_contributors
    client = Adapter::GitHubProject.new(request)

    contributors = []

    (client.get_contributors(@project.github_slug)).each do |contributor|
      contributors.push(contributor.login)
    end

    render json: contributors, status: :ok
  end

  private
    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Project not found" }, status: :not_found
      end
    end

    def project_params
      params.require(:project).permit(:name, :description, :user_id, :is_project_from_github, :github_slug, :is_scoring)
    end
end
