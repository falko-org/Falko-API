class StoriesController < ApplicationController
  include ValidationsHelper

  before_action :set_story, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_sprint(0, :sprint_id)
  end

  before_action only: [:show, :edit, :update, :destroy] do
    validate_story(:id)
  end

  def index
    # @sprint used from validate_sprint(0, :sprint_id)
    @stories = @sprint.stories.reverse
    render json: @stories
  end

  def show
    @story = Story.find(params[:id])
    render json: @story
  end

  def edit
    render json: @story
  end

  def create
    @story = Story.create(story_params)
    @story.sprint = @sprint

    if @story.save
      render json: @story, status: :created
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  def update
    if @story.update(story_params)
      render json: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @story.destroy
  end
  
  private
    def set_story
      @story = Story.find(params[:id])
    end

    def story_params
      params.require(:story).permit(:name, :description, :assign, :pipeline, :initial_date, :story_points)
    end
end
