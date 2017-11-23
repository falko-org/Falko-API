class SprintsController < ApplicationController
  include ValidationsHelper
  include VelocityHelper

  before_action :set_sprint, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy, :get_velocity] do
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
    @sprint = Sprint.new(sprint_params)
    if validate_sprints_date("sprint", sprint_params)
      @sprint.release = @release
      update_amount_of_sprints
      if @sprint.save
        render json: @sprint, status: :created
        # @release used from validate_release
        @sprint.release = @release
        update_amount_of_sprints
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Can not create a sprint outside the range of a release" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if validate_sprints_date("sprint", sprint_params)
      if @sprint.update(sprint_params)
        render json: @sprint
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Can not create a story outside the range of a sprint" }, status: :unprocessable_entity
    end
  end

  # DELETE /sprints/1
  def destroy
    @sprint.destroy
    update_amount_of_sprints
  end

  def get_velocity
    release = @sprint.release
    unless release.project.is_scoring == false
      velocity = get_sprints_informations(release.sprints, @sprint)

      render json: velocity
    else
      render json: { error: "The Velocity is only available in projects that use Story Points" }, status: :unprocessable_entity
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
