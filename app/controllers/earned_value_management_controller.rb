class EarnedValueManagementController < ApplicationController

  before_action :set_earned_value_management, only: [:show, :update, :destroy]

  def create
    evm = EarnedValueManagement.new(earned_value_management_params)
    if evm.save
      render json: evm, status: :created
    else
      render json: evm.errors, status: :unprocessable_entity
    end
  end

  def update
    if @evm.update(earned_value_management_params)
      render json: @evm
    else
      render json: @evm.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @evm
  end

  def destroy
    @evm.destroy
  end

  private

    def earned_value_management_params
      params.require(:earned_value_management).permit(:budget_actual_cost, :planned_release_points, :planned_sprints)
    end

    def set_earned_value_management
      begin
        @evm = EarnedValueManagement.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "EVM not found" }, status: :not_found
      end
    end
end
