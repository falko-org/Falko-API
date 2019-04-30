class RevisionsController < ApplicationController
  include ValidationsHelper

  before_action :set_revision, only: [:show, :update]

  before_action only: [:index, :create] do
    validate_sprint(0, :sprint_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_sprint_dependencies(:id, "revision")
  end

  def_param_group :revision do
    param :done_report, Array, of: String, :desc => "Sprint revision's done report"
    param :undone_report, Array, of: String, :desc => "Sprint revision's undone report"
    param :created_at, Date, "Revision's time of creation", :allow_nil => false
    param :updated_at, Date, "Revision's time of edition", :allow_nil => false
    param :sprint_id, :number, "Id of sprint revised"
  end

  api :GET, "/sprints/:sprint_id/revisions", "Show revisions for a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show all revisions of a specific sprint"
  returns :code => 200, :desc => "Ok" do
    param_group :revision
  end
  example <<-EOS
  {
    "id": 1,
    "done_report": [
        "Story US11 was done."
    ],
    "undone_report": [
        "Story US21 was not done."
    ],
    "created_at": "2019-04-11T15:42:35.826Z",
    "updated_at": "2019-04-11T15:42:35.826Z",
    "sprint_id": 1
  }
  EOS
  def index
    @revision = @sprint.revision
    render json: @revision
  end

  api :POST, "/sprints/:sprint_id/revisions", "Create a revision"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Create revision for a specific sprint'
  param_group :revision
  def create
    create_sprint_dependencies("revision", revision_params)
  end

  api :GET, "/revisions/:id", "Show a revision"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show a revision of a specific sprint"
  returns :code => 200, :desc => "Ok" do
    param_group :revision
  end
  example <<-EOS
  {
    "id": 2,
    "done_report": [
        "Story US12 was done."
    ],
    "undone_report": [
        "Story US22 was not done."
    ],
    "created_at": "2019-04-11T15:42:35.851Z",
    "updated_at": "2019-04-11T15:42:35.851Z",
    "sprint_id": 2
  }
  EOS
  def show
    render json: @revision
  end

  api :PATCH, "/revisions/:id", "Update a revision"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Update revision for a specific sprint'
  param_group :revision
  def update
    if @revision.update(revision_params)
      render json: @revision
    else
      render json: @revision.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/revisions/:id", "Delete a revision"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Delete revision for a specific sprint'
  param_group :revision
  def destroy
    @revision.destroy
  end

  private
    def set_revision
      @revision = Revision.find(params[:id])
    end

    def revision_params
      params.require(:revision).permit(done_report: [], undone_report: [])
    end
end
