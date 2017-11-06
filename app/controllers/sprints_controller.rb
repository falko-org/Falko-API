class SprintsController < ApplicationController
  include ValidationsHelper

  before_action :set_sprint, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_sprint(:id, 0)
  end

  # GET /sprints
  def index
    # @release used from validate_previous_release(:release_id)
    @sprints = @release.sprints.reverse
    render json: @sprints
  end

  # GET /sprints/1
  def show
    render json: @sprint
  end

  # POST /sprints
  def create
    @sprint = Sprint.create(sprint_params)
    @sprint.release = @release

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
      params.require(:sprint).permit(:name, :description, :initial_date, :final_date, :release_id)
    end
end
