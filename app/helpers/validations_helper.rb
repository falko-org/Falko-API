module ValidationsHelper
  def current_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
  end

  def user
    @user = User.find(@project.user_id)
  end

  def project
    @project = Project.find(@release.project_id)
  end

  def validate_user(user_id)
    current_user
    @current_user.id == params[:user_id].to_i
  end

  def validate_current_project(id)
    current_user
    @project = Project.find(params[:id].to_i)
    user

    @current_user.id == @user.id
  end

  def validate_previous_project(project_id)
    current_user
    @project = Project.find(params[:project_id].to_i)
    user

    @current_user.id == @user.id
  end

  def validate_current_release(id)
    current_user
    @release = Release.find(params[:id].to_i)
    project
    user

    @current_user.id == @user.id
  end

  def validate_previous_release(release_id)
    current_user
    @release = Release.find(params[:release_id].to_i)
    project
    user

    @current_user.id == @user.id
  end

  def validate_current_sprint(id)
    current_user
    @sprint = Sprint.find(params[:id].to_i)
    @release = Release.find(@sprint.release_id)
    project
    user

    @current_user.id == @user.id
  end
end
