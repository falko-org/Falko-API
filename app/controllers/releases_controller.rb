class ReleasesController < ApplicationController
  include ValidationsHelper

  before_action only: [:index, :create] do
    validate_project(0, :project_id)
  end

  before_action only: [:show, :edit, :update, :destroy] do
    validate_release(:id, 0)
  end

  def index
    @project = Project.find(params[:project_id])
    @releases = @project.releases.reverse
    render json: @releases
  end

  def new
    @project = Project.find(params[:project_id])
    @release = Release.new
    @release.project = @project

    render json: @release
  end

  def show
    @release = Release.find(params[:id])
    add_amount_of_sprints
    render json: @release
  end

  def edit
    @release = Release.find(params[:id])
    render json: @release
  end

  def create
    @project = Project.find(params[:project_id])
    @release = Release.create(release_params)
    @release.project = @project
    add_amount_of_sprints
    if @release.save
      render json: @release, status: :created
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  def update
    @release = Release.find(params[:id])
    if @release.update(release_params)
      render json: @release
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @release = Release.find(params[:id])
    @release.destroy
  end

  private
    def release_params
      params.require(:release).permit(:name, :description, :amount_of_sprints, :initial_date, :final_date)
    end

    def add_amount_of_sprints
      @release.amount_of_sprints = @release.sprints.count
      @release.save
    end
end
