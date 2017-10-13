class SprintsController < ApplicationController
  include ValidationsHelper

  before_action :set_sprint, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :edit, :update, :destroy] do
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
    if validate_sprint
      render json: @sprint
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /sprints
  def create
    @sprint = Sprint.create(sprint_params)
    @sprint.release = @release

    if @sprint.save
      render json: @sprint, status: :created
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if validate_sprint
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
    if validate_sprint
      @sprint = Sprint.find(params[:id])
      @sprint.destroy
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :initial_date, :final_date, :release_id)
    end
end
