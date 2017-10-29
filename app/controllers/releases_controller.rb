class ReleasesController < ApplicationController
  include ValidationsHelper
  def index
    if validate_previous_project(:project_id)
      @project = Project.find(params[:project_id])
      @releases = @project.releases.reverse
      render json: @releases
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @release = Release.new
    @release.project = @project

    render json: @release
  end

  def show
    if validate_current_release(:id)
      @release = Release.find(params[:id])
      render json: @release
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def edit
    if validate_current_release(:id)
      @release = Release.find(params[:id])
      render json: @release
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def create
    if validate_previous_project(:project_id)
      @project = Project.find(params[:project_id])
      @release = Release.create(release_params)
      @release.project = @project

      if @release.save
        render json: @release, status: :created
      else
        render json: @release.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def update
    if validate_current_release(:id)
      @release = Release.find(params[:id])
      if @release.update(release_params)
        render json: @release
      else
        render json: @release.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def destroy
    if validate_current_release(:id)
      @release = Release.find(params[:id])
      @release.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private
    def release_params
      params.require(:release).permit(:name, :description, :amount_of_sprints, :initial_date, :final_date)
    end
end
