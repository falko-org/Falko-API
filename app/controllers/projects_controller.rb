class ProjectsController < ApplicationController
  before_action :set_project, only: [:destroy, :index, :show]

  def index
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user.id == User.find_by_id(params[:id]).id
      @projects = @current_user.projects
      render json: @projects
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def show
    @project = Project.find(params[:id])
    render json: @project
  end

  def edit
    @project = Project.find(params[:id])
    render json: @project
  end

  def create
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user.id == User.find_by_id(params[:id]).id
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
    @project = Project.find(params[:id])
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

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :user_id)
    end
end
