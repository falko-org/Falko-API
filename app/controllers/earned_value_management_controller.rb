class EarnedValueManagementController < ApplicationController
  include ValidationsHelper
  include Subject

  before_action :set_earned_value_management, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_release(0, :release_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_earned_value_management(:id, 0)
  end

  after_save :update
  after_destroy :destroy

  def index
    @evm = @release.earned_value_management
    render json: @evm
  end

  def create
    test_evm = EarnedValueManagement.count

    if ((test_evm.to_i) == 0)
      evm = EarnedValueManagement.new(earned_value_management_params)
      @release = Release.find(params[:release_id])

      evm.release_id = @release.id

      if evm.save
        # It gets all observable classes by calling super().
        # When an instance of EVM class is created, an observer(EVM Sprint) is added by the super()
        super() # Invokes the create method in Subject module
        render json: evm, status: :created
      else
        render json: evm.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Cant create another EVM" }, status: 401
    end
  end

  def show
    render json: @evm
  end

  def update
    if @evm.update(earned_value_management_params)
      # When the update() method is called, it notifies the observers (EVM Sprint)
      # by asserting that the object has changed
      changed
      # In the method below the EVM Sprint class is notified when there's a change in the Planned Sprints attribute,
      # so that the Evm Sprints class can recalculate its attributes.
      notify_observers

      @evm_sprints = EvmSprint.all
      until (@evm_sprints == 0)
        @evm_sprints.update(evm_sprint_params)
        @evm_sprints.count -= 1
      end

      render json: @evm
    else
      render json: @evm.errors, status: :unprocessable_entity
    end
  end

  def destroy
    changed
    notify_observers
    @evm.destroy
    # delete_observer(observer)
  end

  private
    def earned_value_management_params
      params.require(:earned_value_management).permit(:budget_actual_cost, :planned_release_points, :planned_sprints, :release_id)
    end

    def set_earned_value_management
      @evm = EarnedValueManagement.find(params[:id])
    end
end
