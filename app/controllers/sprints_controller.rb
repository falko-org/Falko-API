class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :update, :destroy]
  # GET /sprints
  def index
    if validate_release
      # @release used from validate_release
      @sprints = @release.sprints.reverse
      render json: @sprints
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # GET /sprints/1
  def show
    if validate_sprint
      render json: @sprint
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # POST /sprints
  def create
    if validate_release
      @sprint = Sprint.create(sprint_params)

      # @release used from validate_release
      @sprint.release = @release

      if @sprint.save
        render json: @sprint, status: :created
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if validate_sprint
      if @sprint.update(sprint_params)
        render json: @sprint
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  # DELETE /sprints/1
  def destroy
    if validate_sprint
      @sprint.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:sprint).permit(:name, :description, :initial_date, :final_date, :release_id)
    end

    def validate_release
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @release = Release.find(params[:release_id].to_i)
      @project = Project.find(@release.project_id)
      (@project.user_id).to_i == @current_user.id
    end

    def validate_sprint
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @sprint = Sprint.find(params[:id])
      @release = Release.find(@sprint.release_id)
      @project = Project.find(@release.project_id)
      @user = User.find(@project.user_id)

      @current_user.id == @user.id
    end
end
