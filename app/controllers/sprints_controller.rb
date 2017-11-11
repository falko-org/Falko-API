class SprintsController < ApplicationController
  include ValidationsHelper

  before_action :set_sprint, only: [:show, :update, :destroy, :burndown]

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
    update_amount_of_sprints
    if @sprint.save
      render json: @sprint, status: :created
      # @release used from validate_release
      @sprint.release = @release
      update_amount_of_sprints
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
    update_amount_of_sprints
  end

  def burndown
    total_points = 0
    burned_stories = {}
    coordenates = []

    for story in @sprint.stories
      total_points += story.story_points
      if(story.pipeline == "Done")
        if(burned_stories[story.final_date] == nil)
          burned_stories[story.final_date] = story.story_points
        else
          burned_stories[story.final_date] += story.story_points
        end
      end
    end


    range = (@sprint.initial_date .. @sprint.final_date)

    range.each do |date|
      if burned_stories[date] == nil
        burned_stories[date] = total_points
      else
        total_points -= burned_stories[date]
        burned_stories[date] = total_points
      end
      coordanate = {x: date, y: burned_stories[date]}
      coordenates.push(coordanate)
    end
    burned_stories = burned_stories.sort_by {|key, value| key}
    render json: coordenates
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
