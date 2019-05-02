class StoriesController < ApplicationController
  include ValidationsHelper

  before_action :set_story, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_sprint(0, :sprint_id)
  end


  before_action only: [:show, :edit, :update, :destroy] do
    validate_sprint_dependencies(:id, "story")
  end

  def_param_group :storie do
    param :name, String, "Storie's name"
    param :description, String, "Storie's description"
    param :assign, String, "Storie's assigned person"
    param :pipeline, String, "Storie's pipeline"
    param :created_at, Date, "Storie's time of creation", allow_nil: false
    param :updated_at, Date, "Storie's time of edition", allow_nil: false
    param :sprint_id, :number, "Id of sprint that the storie belongs"
    param :initial_date, Date, "Storie's initial date"
    param :final_date, Date, "Storie's final date"
    param :story_points, Integer, "Storie's quantity of points"
    param :issue_number, String, "Issue number of the storie"
    param :issue_id, Integer, "Issue's id"
  end

  api :GET, "/sprints/:sprint_id/stories", "Show stories for a sprint"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all stories of a specific sprint"
  returns code: 200, desc: "Ok" do
    param_group :storie
  end
  example <<-EOS
  [
    {
        "id": 2,
        "name": "Story 2",
        "description": "Story 2 us14",
        "assign": "Alax",
        "pipeline": "Done",
        "created_at": "2019-04-11T15:42:34.807Z",
        "updated_at": "2019-04-11T15:42:34.807Z",
        "sprint_id": 1,
        "initial_date": "2017-01-01",
        "final_date": "2017-01-08",
        "story_points": 3,
        "issue_number": "2",
        "issue_id": null
    },
    {
        "id": 1,
        "name": "Story 1",
        "description": "Story 1 us14",
        "assign": "Lucas",
        "pipeline": "Backlog",
        "created_at": "2019-04-11T15:42:34.788Z",
        "updated_at": "2019-04-11T15:42:34.788Z",
        "sprint_id": 1,
        "initial_date": "2017-01-01",
        "final_date": "2017-01-02",
        "story_points": 2,
        "issue_number": "1",
        "issue_id": null
    }
  ]
  EOS
  def index
    # @sprint used from validate_sprint(0, :sprint_id)
    @stories = @sprint.stories.reverse
    render json: @stories
  end

  api :GET, "/sprints/:id/to_do_stories", "Show stories to do"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all stories to do of a specific sprint"
  returns code: 200, desc: "Ok" do
    param_group :storie
  end
  example <<-EOS
  {
    "stories_infos": [
        {
            "name": "Story 1",
            "description": "Story 1 us14",
            "assign": "Lucas",
            "pipeline": "To Do",
            "initial_date": "2017-01-01",
            "story_points": 2,
            "final_date": "2017-01-02",
            "issue_number": "1",
            "id": 46
        }
    ]
  }
  EOS
  def to_do_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "To Do" }

    render json: format_json_output(@stories)
  end

  api :GET, "/sprints/:id/doing_stories", "Show doing stories"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all doing stories of a specific sprint"
  returns code: 200, desc: "Ok" do
    param_group :storie
  end
  example <<-EOS
  {
    "stories_infos": [
        {
            "name": "Story 1",
            "description": "Story 1 us14",
            "assign": "Matheus B",
            "pipeline": "Doing",
            "initial_date": "2017-01-01",
            "story_points": 5,
            "final_date": "2017-01-04",
            "issue_number": "3",
            "id": 47
        }
    ]
  }
  EOS
  def doing_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "Doing" }

    render json: format_json_output(@stories)
  end

  api :GET, "/sprints/:id/done_stories", "Show done stories"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all done stories of a specific sprint"
  returns code: 200, desc: "Ok" do
    param_group :storie
  end
  example <<-EOS
  {
    "stories_infos": [
        {
            "name": "Story 2",
            "description": "Story 2 us14",
            "assign": "Alax",
            "pipeline": "Done",
            "initial_date": "2017-01-01",
            "story_points": 3,
            "final_date": "2017-01-08",
            "issue_number": "2",
            "id": 2
        }
    ]
  }
  EOS
  def done_list
    @sprint = Sprint.find(params[:id])

    @stories = @sprint.stories.select { |story| story.pipeline == "Done" }

    render json: format_json_output(@stories)
  end

  api :GET, "/stories/:id", "Show a storie"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a specific storie"
  returns code: 200, desc: "Ok" do
    param_group :storie
  end
  example <<-EOS
  {
    "id": 1,
    "name": "Story 1",
    "description": "Story 1 us14",
    "assign": "Lucas",
    "pipeline": "Backlog",
    "created_at": "2019-04-11T15:42:34.788Z",
    "updated_at": "2019-04-11T15:42:34.788Z",
    "sprint_id": 1,
    "initial_date": "2017-01-01",
    "final_date": "2017-01-02",
    "story_points": 2,
    "issue_number": "1",
    "issue_id": null
  }
  EOS
  def show
    @story = Story.find(params[:id])
    render json: @story
  end

  api :POST, "/sprints/:sprint_id/stories", "Create a storie"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create a specific storie"
  param_group :storie
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

  api :PATCH, "/stories/:id", "Update a storie"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update a specific storie"
  param_group :storie
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

  api :DELETE, "/stories/:id", "Delete a storie"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete a specific storie"
  param_group :storie
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
