class FeaturesController < ApplicationController
  include ValidationsHelper

  before_action :set_feature, only: [:show, :update, :destroy]

  before_action only: [:index, :create] do
    validate_epic(0, :epic_id)
  end

  before_action only: [:show, :update, :destroy] do
    validate_feature(:id, 0)
  end

  def index
    # @project used from validate_project(0, :project_id)
    @features = @epic.features.reverse
    render json: @features
  end

  def show
    @feature = Feature.find(params[:id])
    render json: @feature
  end

  def create
    @feature = Feature.new(feature_params)
    @feature.epic = Epic.find_by_id(params[:epic_id])
    if @feature.save
      render json: @feature, status: :created
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end

  def update
    if @feature.update(feature_params)
      render json: @feature
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feature.destroy
  end

  private
    def set_feature
      @feature = Feature.find(params[:id])
    end

    def feature_params
      params.require(:feature).permit(:title, :description, :epic_id)
    end
end
