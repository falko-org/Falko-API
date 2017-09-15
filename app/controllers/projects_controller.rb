class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    render json: @projects
  end

  def new
    @project = Project.new
    render json: @project
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
    @project = Project.create(project_params)
    render json: @project
  end

  def update
    @project = Project.update(project_params)
    render json: @project
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
