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

  def verifies_id(idp, project_id, idr, release_id)
    if idp != 0
      id = idp
      @project = Project.find(params[:id].to_i)
    elsif project_id != 0
      @project = Project.find(params[:project_id].to_i)
    elsif idr != 0
      id = idr
      @release = Release.find(params[:id].to_i)
    elsif release_id != 0
      @release = Release.find(params[:release_id].to_i)
    end
  end

  def validate_user(user_id)
    current_user

    if @current_user.id == params[:user_id].to_i
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_project(id, project_id)
    current_user
    verifies_id(id, project_id, 0, 0)
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_release(id, release_id)
    current_user
    verifies_id(0, 0, id, release_id)
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_sprint(id)
    current_user
    @sprint = Sprint.find(params[:id].to_i)
    @release = Release.find(@sprint.release_id)
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end
end
