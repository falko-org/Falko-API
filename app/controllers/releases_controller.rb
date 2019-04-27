class ReleasesController < ApplicationController
  include ValidationsHelper

  before_action :set_release, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_project(0, :project_id)
  end

  before_action only: [:show, :edit, :update, :destroy] do
    validate_release(:id, 0)
  end

  def_param_group :release do
    param :name, String, "Release's name"
    param :description, String, "Release's description"
    param :amount_of_sprints, Integer, "Release's number of sprints"
    param :created_at, Date, "Release's time of creation", :allow_nil => false
    param :updated_at, Date, "Release's time of edition", :allow_nil => false
    param :project_id, :number, "Project's id"
    param :initial_date, Date, "Release's initial date"
    param :final_date, Date, "Release's final date"
  end

  api :GET, "/projects/:project_id/releases", "Show releases for a project"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show all releases of a specific project"
  returns :code => 200, :desc => "Ok" do
    param_group :release
  end
  example <<-EOS
  [
    {
        "id": 2,
        "name": "R2",
        "description": "Agile Release",
        "amount_of_sprints": 0,
        "created_at": "2019-04-11T15:42:34.118Z",
        "updated_at": "2019-04-27T20:55:28.228Z",
        "project_id": 1,
        "initial_date": "2016-01-01",
        "final_date": "2016-12-01"
    },
    {
        "id": 1,
        "name": "R1",
        "description": "RUP Release",
        "amount_of_sprints": 2,
        "created_at": "2019-04-11T15:42:34.101Z",
        "updated_at": "2019-04-27T20:55:28.231Z",
        "project_id": 1,
        "initial_date": "2016-01-01",
        "final_date": "2016-10-01"
    }
  ]
  EOS
  def index
    @releases = @project.releases.reverse
    render json: @releases
  end

  api :GET, "releases/:id", "Show a release for a project"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show a specific release of a project"
  returns :code => 200, :desc => "Ok" do
    param_group :release
  end
  example <<-EOS
  {
    "project_id": 1,
    "id": 1,
    "amount_of_sprints": 2,
    "name": "R1",
    "description": "RUP Release",
    "initial_date": "2016-01-01",
    "final_date": "2016-10-01",
    "created_at": "2019-04-11T15:42:34.101Z",
    "updated_at": "2019-04-27T20:55:28.231Z"
  }
  EOS
  def show
    update_amount_of_sprints
    render json: @release
  end

  api :POST, "/projects/:project_id/releases", "Create a release"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Create release of a project"
  param_group :release
  def create
    @release = Release.create(release_params)
    @release.project = @project
    update_amount_of_sprints
    if @release.save
      render json: @release, status: :created
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, "/releases/:id", "Update a release"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Update release of a project"
  param_group :release
  def update
    if @release.update(release_params)
      render json: @release
    else
      render json: @release.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/releases/:id", "Delete a release"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Delete release of a project"
  param_group :release
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
