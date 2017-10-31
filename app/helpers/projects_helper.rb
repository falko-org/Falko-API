module ProjectsHelper
  def validate_project(user_id, project_id)
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @project = Project.find(params[:project_id].to_i)
    (@project.user_id).to_i == @current_user.id
  end
end
