class SprintsController < ApplicationController
  include ValidationsHelper
  include VelocityHelper
  include BurndownHelper
  include MetricHelper

  before_action :set_sprint, only: [:show, :update, :destroy, :get_burndown]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy, :get_velocity, :get_metrics] do
    validate_sprint(:id, 0)
  end

  def_param_group :sprint do
    param :name, String, "Sprint' name"
    param :description, String, "Sprint's description"
    param :created_at, Date, "Sprint's time of creation", :allow_nil => false
    param :updated_at, Date, "Sprint's time of edition", :allow_nil => false
    param :release_id, :number, "Id of release that the sprint belongs"
    param :initial_date, Date, "Sprint's initial date"
    param :final_date, Date, "Sprint's final date"
  end

  api :GET, "/releases/:release_id/sprints", "Show sprints for a release"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show all sprints of a specific release"
  returns :code => 200, :desc => "Ok" do
    param_group :sprint
  end
  example <<-EOS
  [
    {
        "id": 2,
        "name": "Sprint 2 - P1",
        "description": "Second Sprint",
        "created_at": "2019-04-11T15:42:34.244Z",
        "updated_at": "2019-04-11T15:42:34.244Z",
        "release_id": 1,
        "initial_date": "2017-01-01",
        "final_date": "2017-01-07"
    },
    {
        "id": 1,
        "name": "Sprint 1 - P1",
        "description": "First Sprint",
        "created_at": "2019-04-11T15:42:34.223Z",
        "updated_at": "2019-04-11T15:42:34.223Z",
        "release_id": 1,
        "initial_date": "2016-08-01",
        "final_date": "2016-10-01"
    }
  ]
  EOS
  def index
    @sprints = @release.sprints.reverse
    render json: @sprints
  end

  api :GET, "/sprints/:id", "Show a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show a specific sprint"
  returns :code => 200, :desc => "Ok" do
    param_group :sprint
  end
  example <<-EOS
  {
    "id": 1,
    "name": "Sprint 1 - P1",
    "description": "First Sprint",
    "created_at": "2019-04-11T15:42:34.223Z",
    "updated_at": "2019-04-11T15:42:34.223Z",
    "release_id": 1,
    "initial_date": "2016-08-01",
    "final_date": "2016-10-01"
  }
  EOS
  def show
    render json: @sprint
  end

  api :POST, "/releases/:release_id/sprints", "Create a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Create a specific sprint'
  param_group :sprint
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

  api :PATCH, "/sprints/:id", "Update a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Update a specific sprint'
  param_group :sprint
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

  api :DELETE, "/sprints/:id", "Update a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description 'Delete a specific sprint'
  param_group :sprint
  def destroy
    @sprint.destroy
    update_amount_of_sprints
  end

  api :GET, "/sprints/:id/velocity", "Show velocity of a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show velocity of a specific sprint"
  returns :code => 200, :desc => "Ok" do
    param_group :sprint
  end
  example <<-EOS
  {
    "total_points": [
        5
    ],
    "completed_points": [
        3
    ],
    "names": [
        "Sprint 1 - P1"
    ],
    "velocities": [
        3
    ]
  }
  EOS
  def get_velocity
    release = @sprint.release
    if release.project.is_scoring == true
      velocity = get_sprints_informations(release.sprints, @sprint)

      render json: velocity
    else
      render json: { error: "The Velocity is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  api :GET, "/sprints/:id/burndown", "Show burndown of a sprint"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  error :code => 500, :desc => "Internal Server Error"
  description "Show burndown of a specific sprint"
  returns :code => 200, :desc => "Ok" do
    param_group :sprint
  end
  example <<-EOS
  {
    "x": [
        "2016-08-01",
        "2016-08-02",
        "2016-08-03",
        "2016-08-04",
        "2016-08-05",
        "2016-08-06",
        "2016-08-07",
        "2016-08-08",
        "2016-08-09",
        "2016-08-10",
        "2016-08-11",
        "2016-08-12",
        "2016-08-13",
        "2016-08-14",
        "2016-08-15",
        "2016-08-16",
        "2016-08-17",
        "2016-08-18",
        "2016-08-19",
        "2016-08-20",
        "2016-08-21",
        "2016-08-22",
        "2016-08-23",
        "2016-08-24",
        "2016-08-25",
        "2016-08-26",
        "2016-08-27",
        "2016-08-28",
        "2016-08-29",
        "2016-08-30",
        "2016-08-31",
        "2016-09-01",
        "2016-09-02",
        "2016-09-03",
        "2016-09-04",
        "2016-09-05",
        "2016-09-06",
        "2016-09-07",
        "2016-09-08",
        "2016-09-09",
        "2016-09-10",
        "2016-09-11",
        "2016-09-12",
        "2016-09-13",
        "2016-09-14",
        "2016-09-15",
        "2016-09-16",
        "2016-09-17",
        "2016-09-18",
        "2016-09-19",
        "2016-09-20",
        "2016-09-21",
        "2016-09-22",
        "2016-09-23",
        "2016-09-24",
        "2016-09-25",
        "2016-09-26",
        "2016-09-27",
        "2016-09-28",
        "2016-09-29",
        "2016-09-30",
        "2016-10-01"
    ],
    "y": [
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5,
        5
    ],
    "ideal_line": [
        5,
        4.918032786885246,
        4.836065573770492,
        4.754098360655737,
        4.672131147540984,
        4.590163934426229,
        4.508196721311475,
        4.426229508196721,
        4.344262295081967,
        4.2622950819672125,
        4.180327868852459,
        4.0983606557377055,
        4.016393442622951,
        3.9344262295081966,
        3.8524590163934427,
        3.7704918032786883,
        3.6885245901639347,
        3.6065573770491803,
        3.5245901639344264,
        3.442622950819672,
        3.360655737704918,
        3.2786885245901636,
        3.19672131147541,
        3.114754098360656,
        3.0327868852459017,
        2.9508196721311473,
        2.8688524590163933,
        2.7868852459016393,
        2.7049180327868854,
        2.6229508196721314,
        2.540983606557377,
        2.459016393442623,
        2.3770491803278686,
        2.2950819672131146,
        2.2131147540983607,
        2.1311475409836063,
        2.0491803278688527,
        1.9672131147540983,
        1.8852459016393441,
        1.8032786885245902,
        1.721311475409836,
        1.6393442622950818,
        1.557377049180328,
        1.4754098360655736,
        1.3934426229508197,
        1.3114754098360657,
        1.2295081967213115,
        1.1475409836065573,
        1.0655737704918031,
        0.9836065573770492,
        0.9016393442622951,
        0.8196721311475409,
        0.7377049180327868,
        0.6557377049180328,
        0.5737704918032787,
        0.4918032786885246,
        0.40983606557377045,
        0.3278688524590164,
        0.2459016393442623,
        0.1639344262295082,
        0.0819672131147541,
        0
    ]
  }
  EOS
  def get_burndown
    project = @sprint.release.project
    if project.is_scoring == true
      burned_stories = {}
      coordenates = []
      date_axis = []
      points_axis = []
      ideal_line = []

      total_points = get_total_points(@sprint)
      burned_stories = get_burned_points(@sprint, burned_stories)

      range_dates = (@sprint.initial_date .. @sprint.final_date)

      set_dates_and_points(burned_stories, date_axis, points_axis, range_dates, total_points)
      days_of_sprint = date_axis.length - 1
      set_ideal_line(days_of_sprint, ideal_line, total_points)

      coordenates = { x: date_axis, y: points_axis, ideal_line: ideal_line }

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
