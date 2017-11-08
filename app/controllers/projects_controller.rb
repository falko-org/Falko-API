class ProjectsController < ApplicationController
  include ValidationsHelper

  before_action :set_project, only: [:destroy, :show, :get_contributors]

  before_action only: [:index, :create] do
    validate_user(:user_id)
  end

  before_action only: [:show, :edit, :update, :destroy] do
    validate_project(:id, 0)
  end

  def index
    @projects = User.find(params[:user_id]).projects
    render json: @projects
  end

  def github_projects_list
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @client = Octokit::Client.new(access_token: @current_user.access_token)

    user = @client.user.login
    user_repos = []
    @repos = @client.repositories
    @form_params = { user: [] }
    @form_params[:user].push(login: user)
    @repos.each do |repo|
      user_repos.push(repo.name)
    end
    @form_params[:user].push(repos: user_repos)

    @orgs = @client.organizations
    @form_params2 = { orgs: [] }
    @orgs.each do |org|
      repos = @client.organization_repositories(org.login)
      repos_names = []
      repos.each do |repo|
        repos_names.push(repo.name)
      end
      @form_params2[:orgs].push(name: org.login, repos: repos_names)
    end

    @form_params3 = @form_params2.merge(@form_params)


    render json: @form_params3
  end

  def show
    render json: @project
  end

  def edit
    render json: @project
  end

  def create
    @project = Project.create(project_params)
    @project.user_id = @current_user.id

    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

  def get_contributors
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @client = Octokit::Client.new(access_token: @current_user.access_token)

    contributors = []

    @client.contributors("fga-gpp-mds/Falko-2017.2-BackEnd").each do |contributor|
      contributors.push(contributor.login)
    end

    render json: contributors
  end

  def set_assignee
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @client = Octokit::Client.new(access_token: @current_user.access_token)

    @client.add_assignees("fga-gpp-mds/Falko-2017.2-BackEnd", 66, ["MatheusRich", "drianne"])
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :user_id, :check_project)
    end
end
