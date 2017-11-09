class RevisionsController < ApplicationController
  include ValidationsHelper

  before_action :set_revision, only: [:show, :update]

  before_action only: [:index, :create] do
    validate_sprint(0, :sprint_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_sprint_dependencies(:id, "revision")
  end

  def index
    @revision = @sprint.revision
    render json: @revision
  end

  def create
    create_sprint_dependencies("revision", revision_params)
  end

  def show
    render json: @revision
  end

  def update
    if @revision.update(revision_params)
      render json: @revision
    else
      render json: @revision.errors, status: :unprocessable_entity
    end
  end

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
