class GradeController < ApplicationController
  include MetricHelper
  
  def update
  end

  def create
    @grade = Grade.new(grade_params)
    if @grade.save
      render json: @grade, status: :created
    else
      render json: @grade.errors, status: :unprocessable_entity
  end

  def show
    final_metric = get_metrics(@grade)

    render json: final_metric
  end

  def grade_params
    params.require(:grade).permit(:weight_debt, :weight_velocity, :weight_burndown)
  end
end
