class EvmSprintController < ApplicationController
  before_action :set_evm_sprint, only: [:create, :show, :update, :destroy]

  def index
    evm_sprints = @evm.evm_sprints
    render json: evm_sprints
  end

  def create
    evm_sprint = EarnedValueManagement.new(evm_sprint_params)
    evm_sprint.earned_value_management_id = @evm.id

    if evm_sprint.save
      calculate_evm_sprint_values(@evm, evm_sprint)

      render json: evm_sprint, status: :created
    else
      render json: evm_sprint.errors, status: :unprocessable_entity
    end
  end

  def update
    if @evm_sprint.update(evm_sprint_params)
      calculate_evm_sprint_values(@evm, @evm_sprint)

      render json: @evm_sprint
    else
      render json: @evm_sprint.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @evm_sprint
  end

  def destroy
    @evm_sprint.destroy
  end

  private

    def evm_sprint_params
      params.require(:evm_sprint).permit(:completed_points, :added_points)
    end

    def set_evm_sprint
      begin
        @evm = EarnedValueManagement.find(params[:earned_value_management_id])
      rescue
        render json: { errors: "EVM not found" }, status: :not_found
      end
      begin
        @evm_sprint = EvmSprint.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "EVM Sprint not found" }, status: :not_found
      end
    end
end
