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

  def release
    @release = Release.find(@sprint.release_id)
  end

  def sprint
    @sprint = Sprint.find(@story.sprint_id)
  end

  def verifies_id(current_id, previous_id, component_type)
    if component_type == "project" && current_id != 0
      id = current_id
      @project = Project.find(params[:id].to_i)
    elsif component_type == "project" && previous_id != 0
      project_id = previous_id
      @project = Project.find(params[:project_id].to_i)
    elsif component_type == "release" && current_id != 0
      id = current_id
      @release = Release.find(params[:id].to_i)
    elsif component_type == "release" && previous_id != 0
      release_id = previous_id
      @release = Release.find(params[:release_id].to_i)
    elsif component_type == "sprint" && current_id != 0
      id = current_id
      @sprint = Sprint.find(params[:id].to_i)
    elsif component_type == "sprint" && previous_id != 0
      sprint_id = previous_id
      @sprint = Sprint.find(params[:sprint_id].to_i)
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
    verifies_id(id, project_id, "project")
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_release(id, release_id)
    current_user
    verifies_id(id, release_id, "release")
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_sprint(id, sprint_id)
    current_user
    verifies_id(id, sprint_id, "sprint")
    release
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def validate_story(id)
    current_user
    @story = Story.find(params[:id].to_i)
    sprint
    release
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end
end
