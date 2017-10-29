class SprintsController < ApplicationController
  include ValidationsHelper
  before_action :set_sprint, only: [:show, :update, :destroy]
  # GET /sprints
  def index
    if validate_previous_release(:release_id)
      # @release used from validate_previous_release(:release_id)
      @sprints = @release.sprints.reverse
      render json: @sprints
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # GET /sprints/1
  def show
    if validate_current_sprint(:id)
      render json: @sprint
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # POST /sprints
  def create
    if validate_previous_release(:release_id)
      @sprint = Sprint.create(sprint_params)

      # @release used from validate_previous_release(:release_id)
      @sprint.release = @release

      if @sprint.save
        render json: @sprint, status: :created
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if validate_current_sprint(:id)
      if @sprint.update(sprint_params)
        render json: @sprint
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # DELETE /sprints/1
  def destroy
    if validate_current_sprint(:id)
      @sprint.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :initial_date, :final_date, :release_id)
    end
end
