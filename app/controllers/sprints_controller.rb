class SprintsController < ApplicationController
before_action :set_sprint, only: [:show, :update]

  # GET /sprints
  def index
    if validate_project
      @sprints = Project.find((params[:project_id]).to_i).sprints
      render json: @sprints
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # GET /sprints/1
  def show
    if validate_sprint
      render json: @sprint
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /sprints
  def create
    if validate_project
      @sprint = Sprint.create(sprint_params)
      @sprint.project_id = @project.id

      if @sprint.save
        render json: @sprint, status: :created
      else
        render json: @sprint.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
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
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # DELETE /sprints/1
  def destroy
    if validate_sprint
      @sprint = Sprint.find(params[:id])
      @sprint.destroy
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sprint_params
    params.require(:sprint).permit(:name, :description, :project_id, :start_date, :end_date)
  end

  def validate_project
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @project = Project.find(params[:project_id].to_i)
    (@project.user_id).to_i == @current_user.id
  end

  def validate_sprint
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @sprint = Sprint.find(params[:id])
    @project = Project.find(@sprint.project_id)
    @user = User.find(@project.user_id)

    @current_user.id == @user.id
  end

end
