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

  def sprint(component_type)
    if component_type == "story"
      @sprint = Sprint.find(@story.sprint_id)
    elsif component_type == "revision"
      @sprint = Sprint.find(@revision.sprint_id)
    elsif component_type == "retrospective"
      @sprint = Sprint.find(@retrospective.sprint_id)
    end
  end

  def verifies_id(current_id, previous_id, component_type)
    if component_type == "user" && current_id != 0
      id = current_id
      @user = User.find(params[:id].to_i)
    elsif component_type == "user" && previous_id != 0
      user_id = previous_id
      @user = User.find(params[:user_id].to_i)
    elsif component_type == "project" && current_id != 0
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

  def validate_user(id, user_id)
    current_user
    verifies_id(id, user_id, "user")

    if @current_user.id == @user.id
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

  def validate_sprint_dependencies(id, component_type)
    current_user
    if component_type == "story"
      @story = Story.find(params[:id].to_i)
      sprint("story")
    elsif component_type == "revision"
      @revision = Revision.find(params[:id].to_i)
      sprint("revision")
    elsif component_type == "retrospective"
      @retrospective = Retrospective.find(params[:id].to_i)
      sprint("retrospective")
    end
    release
    project
    user

    if @current_user.id == @user.id
      return true
    else
      render json: { error: "Not Authorized" }, status: 401
    end
  end

  def update_amount_of_sprints
    @release.amount_of_sprints = @release.sprints.count
    @release.save
  end
end
