class ProjectsController < ApplicationController
  before_action :set_project, only: [:destroy, :show]

  def index
    if validate_user
      @projects = User.find(params[:user_id]).projects
      render json: @projects
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def github_projects_list
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @client = Octokit::Client.new(access_token: @current_user.access_token)

    @repos = @client.repositories
    @form_params = { user: [] }
    @repos.each do |repo|
      @form_params[:user].push(repo.name)
    end

    @orgs = @client.organizations

    @form_params2 = { orgs: [] }
    @orgs.each do |org|
      repos = @client.organization_repositories(org.login)
      repos_names = []
      repos.each do |repo|
        repos_names.push(repo.name)
      end
      @form_params2[:orgs].push({ name: org.login, repos: repos_names })
    end

      @form_params3 = @form_params2.merge(@form_params)

    render json: @form_params3
  end

  def show
    if validate_project
      render json: @project
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def edit
    if validate_project
      render json: @project
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def create
    if validate_user
      @project = Project.create(project_params)
      @project.user_id = @current_user.id

      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def update
    if validate_project
      if @project.update(project_params)
        render json: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def destroy
    if validate_project
      @project = Project.find(params[:id])
      @project.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :user_id)
    end

    def validate_user
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @current_user.id == params[:user_id].to_i
    end

    def validate_project
      @project = Project.find(params[:id])
      # @current_user used from validate_user
      @current_user.id == (@project.user_id).to_i
    end
end
