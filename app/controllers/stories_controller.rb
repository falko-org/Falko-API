class StoriesController < ApplicationController
  include ValidationsHelper

  before_action :set_story, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_sprint(0, :sprint_id)
  end


  before_action only: [:show, :edit, :update, :destroy] do
    validate_sprint_dependencies(:id, "story")
  end

  def index
    # @sprint used from validate_sprint(0, :sprint_id)
    @stories = @sprint.stories.reverse
    render json: @stories
  end

  def to_do_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "To Do" }

    render json: format_json_output(@stories)
  end

  def doing_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "Doing" }

    render json: format_json_output(@stories)
  end

  def done_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "Done" }

    render json: format_json_output(@stories)
  end

  def show
    @story = Story.find(params[:id])
    render json: @story
  end

  def create
    @story = Story.create(story_params)
    @story.sprint = @sprint
    if validate_stories(@story.story_points, 0, :sprint_id)
      if @story.save
        render json: @story, status: :created
      else
        render json: @story.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Story points have to be set" }, status: :unprocessable_entity
    end
    end

  def update
    if story_params[:pipeline] == "Done"
      @story.final_date = Date.today
    end
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

    def format_json_output(stories)
      form_params = { stories_infos: [] }

      if stories != nil
        if stories.kind_of?(Array)
          stories.each do |story|
            form_params[:stories_infos].push(name: story.name, description: story.description, assign: story.assign, pipeline: story.pipeline, initial_date: story.initial_date, story_points: story.story_points, final_date: story.final_date, issue_number: story.issue_number, id: story.id)
          end
        else
          form_params[:stories_infos].push(name: stories.name, description: stories.description, assign: stories.assign, pipeline: stories.pipeline, initial_date: stories.initial_date, story_points: stories.story_points, final_date: stories.final_date, issue_number: stories.issue_number, id: stories.id)
        end
      end

      form_params
    end

    def story_params
      params.require(:story).permit(:name, :description, :assign, :pipeline, :initial_date, :story_points, :final_date, :issue_number, :issue_id)
    end
end
