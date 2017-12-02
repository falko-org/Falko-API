class SprintsController < ApplicationController
  include ValidationsHelper
  include VelocityHelper

  before_action :set_sprint, only: [:show, :update, :destroy, :get_burndown]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy, :get_velocity] do
    validate_sprint(:id, 0)
  end

  def index
    @sprints = @release.sprints.reverse
    render json: @sprints
  end

  def show
    render json: @sprint
  end

  def create
    @sprint = Sprint.new(sprint_params)
    if validate_sprints_date("sprint", sprint_params)
      @sprint.release = @release
      update_amount_of_sprints
      if @sprint.save
        render json: @sprint, status: :created
        @sprint.release = @release
        update_amount_of_sprints
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Can not create a sprint outside the range of a release" }, status: :unprocessable_entity
    end
  end

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

  def destroy
    @sprint.destroy
    update_amount_of_sprints
  end

  def get_velocity
    release = @sprint.release
    if release.project.is_scoring == true
      velocity = get_sprints_informations(release.sprints, @sprint)

      render json: velocity
    else
      render json: { error: "The Velocity is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  def get_burndown
    project = @sprint.release.project
    if project.is_scoring != false
      total_points = 0
      burned_stories = {}
      coordenates = []

      for story in @sprint.stories
        total_points += story.story_points
        if story.pipeline == "Done"
          if burned_stories[story.final_date] == nil
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
        coordanate = { x: date, y: burned_stories[date] }
        coordenates.push(coordanate)
      end
      burned_stories = burned_stories.sort_by { |key, value| key }
      render json: coordenates
    else
      render json: { error: "The Burndown Chart is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  private
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    def sprint_params
      params.require(:sprint).permit(:name, :description, :initial_date, :final_date, :release_id)
    end
end
