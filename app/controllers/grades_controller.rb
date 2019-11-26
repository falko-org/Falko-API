class GradesController < ApplicationController
  include MetricHelper
  include GradesDoc

  before_action :set_grade, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_project(0, :project_id)
  end

  before_action only: [:show, :update] do
    validate_grade_and_release(:id, 0, "grade")
  end

  def index
    grade = @project.grade
    render json: grade
  end

  def create
    if @project.grade.blank?
      grade = Grade.new(grade_params)
      grade.project = @project

      if grade.save
        render json: grade, status: :created
      else
        render json: grade.errors, status: :unprocessable_entity
      end
    else
      render json: @project.grade
    end
  end

  def update
    if @grade.update(grade_params)
      render json: @grade
    else
      render json: @grade.errors, status: :unprocessable_entity
    end
  end

  def show
    final_metric = get_metrics(@grade)
    render json: final_metric
  end

  def destroy
    @grade.destroy
  end

  private
    def grade_params
      params.require(:grade).permit(:weight_debts, :weight_velocity, :weight_burndown)
    end

    def set_grade
      @grade = Grade.find(params[:id])
    end
end
