class ReleasesController < ApplicationController
  def index
    @releases = Release.all
    render json: @releases
  end

  def new
    @release = Release.new
    render json: @release
  end

  def show
    @release = Release.find(params[:id])
    render json: @release
  end

  def edit
    @release = Release.find(params[:id])
    render json: @release
  end

  def create
    @release = Release.create(release_params)
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
    params.require(:release).permit(:name, :description, :amount_of_sprints)
  end
end
