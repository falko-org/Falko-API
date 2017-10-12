class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :update, :destroy]

  # GET /sprints
  def index
    @sprints = Project.find((params[:project_id]).to_i).sprints
    render json: @sprints
  end

  # GET /sprints/1
  def show
    render json: @sprint
  end

  # POST /sprints
  def create
    @sprint = Sprint.new(sprint_params)
    @sprint.project_id = params[:project_id]

    if @sprint.save
      render json: @sprint, status: :created
    else
      render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if @sprint.update(sprint_params)
      render json: @sprint
    else
      render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sprints/1
  def destroy
    @sprint.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :project_id, :start_date, :end_date)
    end
end
