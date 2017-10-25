class ReleasesController < ApplicationController
  def index
    if validate_project
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
    if validate_releases
      @release = Release.find(params[:id])
      render json: @release
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def edit
    if validate_releases
      @release = Release.find(params[:id])
      render json: @release
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def create
    if validate_project
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
    if validate_releases
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
    if validate_releases
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

    def validate_project
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @project = Project.find(params[:project_id].to_i)
      (@project.user_id).to_i == @current_user.id
    end

    def validate_releases
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @release = Release.find(params[:id])
      @project = Project.find(@release.project_id)
      @user = User.find(@project.user_id)

      @current_user.id == @user.id
    end
end
