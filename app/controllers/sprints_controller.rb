class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :update, :destroy]

  # GET /sprints
  def index
    if Project.validate
      @sprints = Project.find((params[:project_id]).to_i).sprints
      render json: @sprints
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # GET /sprints/1
  def show
    if Project.validate
      render json: @sprint
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /sprints
  def create
    if Project.validate
      @sprint = Sprint.new(sprint_params)
      @sprint.project_id = params[:project_id]

      if @sprint.save
        render json: @sprint, status: :created
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if Project.validate
      if @sprint.update(sprint_params)
        render json: @sprint
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # DELETE /sprints/1
  def destroy
    if Project.validate
      @sprint.destroy
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
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
