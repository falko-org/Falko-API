class RetrospectivesController < ApplicationController
  before_action :set_retrospective, only:   [:show, :edit, :update]

  def index
    set_sprint
    @retrospective = @sprint.retrospective

    if @retrospective == nil
      @retrospective = []
    end

    render json: @retrospective
  end

  def create
    set_sprint

    if @sprint.retrospective == nil
      if validate_sprint
        @retrospective = Retrospective.create(retrospective_params)
        @retrospective.sprint_id = @sprint.id

        if @retrospective.save
          render json: @retrospective, status: :created
        else
          render json: @retrospective.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Not Authorized" }, status: 401
      end
    else
      render json: { error: "Cannot create multiple retrospectives" }, status: 403
    end
  end

  def show
    if validate_retrospective
      render json: @retrospective
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def edit
    if validate_retrospective
      render json: @retrospective
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def update
    if validate_retrospective
      if @retrospective.update(retrospective_params)
        render json: @retrospective
      else
        render json: @retrospective.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def destroy
    if validate_retrospective
      @retrospective = Retrospective.find(params[:id])
      @retrospective.destroy
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  private

    def set_sprint
      @sprint = Sprint.find(params[:sprint_id])
    end

    def set_retrospective
      @retrospective = Retrospective.find(params[:id])
    end

    def retrospective_params
      params.require(:retrospective).permit(:sprint_report, positive_points: [], negative_points: [] , improvements: [])
    end

    def validate_retrospective
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @retrospective = Retrospective.find(params[:id])
      @sprint = Sprint.find(@retrospective.sprint_id)
      @project = Project.find(@sprint.project_id)
      @user = User.find(@project.user_id)

      @current_user.id == @user.id
    end

    def validate_sprint
      @current_user = AuthorizeApiRequest.call(request.headers).result
      set_sprint
      @project = Project.find(@sprint.project_id)
      @user = User.find(@project.user_id)

      @current_user.id == @user.id
    end

end
