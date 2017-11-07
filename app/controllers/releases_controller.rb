class ReleasesController < ApplicationController
  include ValidationsHelper

  before_action :set_release, only: [:show, :update, :destroy]

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

  def show
    update_amount_of_sprints
    render json: @release
  end

  def create
    @project = Project.find(params[:project_id])
    @release = Release.create(release_params)
    @release.project = @project
    update_amount_of_sprints
    if @release.save
      render json: @release, status: :created
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  def update
    if @release.update(release_params)
      render json: @release
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @release.destroy
  end

  private
    def set_release
      @release = Release.find(params[:id])
    end

    def release_params
      params.require(:release).permit(:name, :description, :amount_of_sprints, :initial_date, :final_date)
    end
end
