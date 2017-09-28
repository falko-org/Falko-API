class ProjectsController < ApplicationController
 skip_before_action :authenticate_request

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
    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
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

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
