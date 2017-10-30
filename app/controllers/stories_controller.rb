class StoriesController < ApplicationController
  include ProjectsHelper
  def index
    if validate_sprint
      # @sprint used from validate_sprint
      @stories = @sprint.stories.reverse
      render json: @stories
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def show
    if validate_story
      @story = Story.find(params[:id])
      render json: @story
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def edit
    if validate_story
      @story = Story.find(params[:id])
      render json: @story
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def create
    if validate_sprint
      @story = Story.create(story_params)

      # @sprint used from validate_sprint
      @story.sprint = @sprint

      if @story.save
        render json: @story, status: :created
      else
        render json: @story.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def update
    if validate_story
      @story = Story.find(params[:id])
      if @story.update(story_params)
        render json: @story
      else
        render json: @story.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def destroy
    if validate_story
      @story = Story.find(params[:id])
      @story.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private

    def story_params
      params.require(:story).permit(:name, :description, :assign, :pipeline, :initial_date)
    end

    def validate_sprint
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @sprint_user = Sprint.find(params[:sprint_id].to_i).release.project.user_id
      @sprint = Sprint.find(params[:sprint_id].to_i)

      @current_user.id == @sprint_user
    end

    def validate_story
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @story_user = Story.find(params[:id]).sprint.release.project.user_id

      @current_user.id == @story_user
    end
end
