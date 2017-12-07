class EarnedValueManagementController < ApplicationController
  include ValidationsHelper
  
  before_action :set_earned_value_management, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_earned_value_management(:id, 0)
  end

  def index
    @evm = @release.earned_value_management
    render json: @evm
  end

  def create
    test_evm = EarnedValueManagement.count
    
    if (test_evm.to_i) == 0
      evm = EarnedValueManagement.new(earned_value_management_params)
      @release = Release.find(params[:release_id])

      evm.release_id = @release.id

      if evm.save
        render json: evm, status: :created
      else
        render json: evm.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Cant create another EVM" }, status: 401
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
      params.require(:earned_value_management).permit(:budget_actual_cost, :planned_release_points, :planned_sprints, :release_id)
    end

    def set_earned_value_management
      @evm = EarnedValueManagement.find(params[:id])
    end
end
