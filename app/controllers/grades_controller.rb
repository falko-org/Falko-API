class GradesController < ApplicationController
  include MetricHelper
  
  before_action :set_grade, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_project(0, :project_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_release(:id, 0)
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
    # issue: Caso o projeto não tenha releases ou a release não tenha sprints, isto deve ser tratado
    # begin
      final_metric = get_metrics(@grade)
      render json: final_metric
    # rescue HasNoSprints
    #   render json: { errors: "Could not calculate grade. This release has no sprints" },
    #     status: :unprocessable_entity
    # rescue HasNoReleases
    #   render json: { errors: "Could not calculate grade. This project has no releases" },
    #     status: :unprocessable_entity
    # end
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
