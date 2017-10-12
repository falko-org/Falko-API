class ProjectsController < ApplicationController
before_action :set_project, only: [:destroy, :show]

  def index
    if User.validate
      @project = User.find((params[:user_id]).to_i).projects
      render json: @project
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def show
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if User.validate
      @project = Project.find(params[:id])
      if @current_user.id == (@project.user_id).to_i
        render json: @project
      else
        render json: { error: 'Not Authorized' }, status: 401
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def edit
    if User.validate
      @project = Project.find(params[:id])
      render json: @project
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def create
    if User.validate
      @project = Project.create(project_params)
      @project.user_id = @current_user.id

      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def update
    if User.validate
      @project = Project.find(params[:id])
      if @project.update(project_params)
        render json: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def destroy
    if User.validate
      @project = Project.find(params[:id])
      @project.destroy
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def validate
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @current_user.id == params[:project_id].to_i
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :user_id)
  end

end
