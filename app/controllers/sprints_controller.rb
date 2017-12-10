class SprintsController < ApplicationController
  include ValidationsHelper
  include VelocityHelper
  include BurndownHelper

  before_action :set_sprint, only: [:show, :update, :destroy, :get_burndown]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy, :get_velocity, :get_velocity_variance, :get_debts, :get_burndown_variance] do
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

  def get_velocity_variance
    release = @sprint.release
    if release.project.is_scoring == true
      release = @sprint.release
      velocity = get_sprints_informations(release.sprints, @sprint)

      total_sprints_points = velocity[:total_points]
      velocities = velocity[:velocities]

      amount = release.sprints.count
      variance = 0

      for i in 0..(amount - 1)
        variance += (total_sprints_points[i] - velocities[i])
      end

      variance = variance/amount

      render json: variance
    else
      render json: { error: "The Velocity variance is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  def get_burndown
    project = @sprint.release.project
    if project.is_scoring == true
      burned_stories = {}
      coordenates = []
      date_axis = []
      points_axis = []
      ideal_line = []

      total_points = get_burned_points(@sprint, burned_stories)

      range_dates = (@sprint.initial_date .. @sprint.final_date)
      get_dates(burned_stories, date_axis, points_axis, range_dates, total_points)

      days_of_sprint = date_axis.length - 1
      set_ideal_line(days_of_sprint, ideal_line, total_points)

      coordenates = { x: date_axis, y: points_axis, ideal_line: ideal_line }
      burned_stories = burned_stories.sort_by { |key, value| key }

      render json: coordenates
    else
      render json: { error: "The Burndown Chart is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  def get_burndown_variance
    project = @sprint.release.project
    if project.is_scoring == true
      burned_stories = {}
      date_axis = []
      points_axis = []
      ideal_line = []

      total_points = get_burned_points(@sprint, burned_stories)

      range_dates = (@sprint.initial_date .. @sprint.final_date)
      get_dates(burned_stories, date_axis, points_axis, range_dates, total_points)

      days_of_sprint = date_axis.length - 1
      set_ideal_line(days_of_sprint, ideal_line, total_points)

      variance = 0

      for i in 0..(date_axis.length - 2)
        variance = (points_axis[i] - points_axis[i+1]) + (ideal_line[i] - ideal_line[i+1])
      end

      variance = Float(variance) / date_axis.length

      render json: variance
    else
      render json: { error: "The Burndown variance is only available in projects that use Story Points" }, status: :unprocessable_entity
    end
  end

  def get_debts
    release = @sprint.release
    if release.project.is_scoring == true
      velocity = get_sprints_informations(release.sprints, @sprint)

      planned_points = 0
      burned_points = 0

      for i in 0..(release.sprints.length - 1)
        planned_points = planned_points + velocity[:total_points][i]
        burned_points = burned_points + velocity[:completed_points][i]
      end

      debts = Float(planned_points - burned_points)/planned_points

      render json: debts
    else
      render json: { error: "Debts is only available in projects that use Story Points" }, status: :unprocessable_entity
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
