class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    json_response(@projects)
  end

  def new
    @project = Project.new
    json_response(@project)
  end

  def show
    @project = Project.find(params[:id])
    json_response(@project)
  end

  def edit
    @project = Project.find(params[:id])
    json_response(@project)
  end

  def create
    @project = Project.create(project_params)
    json_response(@project, :created)
  end

  def update
    @project = Project.update(project_params)
    head :no_content
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    head :no_content
  end

  private

  def project_params
    params.permit(:name, :description)
  end

end
