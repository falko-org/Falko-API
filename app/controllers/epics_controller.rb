class EpicsController < ApplicationController
  include ValidationsHelper

  before_action :set_epic, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_project(0, :project_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_epic(:id, 0)
  end

  # GET /epics
  def index
    @epics = @project.epics.reverse

    render json: @epics
  end

  # GET /epics/1
  def show
    @epic = Epic.find(params[:id])
    render json: @epic
  end

  # POST /epics
  def create
    @epic = Epic.new(epic_params)
    @epic.project = @project
    if @epic.save
      render json: @epic, status: :created, location: @epic
    else
      render json: @epic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /epics/1
  def update
    if @epic.update(epic_params)
      render json: @epic
    else
      render json: @epic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /epics/1
  def destroy
    @epic.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epic
      @epic = Epic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epic_params
      params.require(:epic).permit(:title, :description, :project_id)
    end
end
