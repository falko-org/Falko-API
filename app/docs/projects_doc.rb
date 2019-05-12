module ProjectsDoc
  extend Apipie::DSL::Concern

  def_param_group :project do
    param :name, String, "Project's name"
    param :description, String, "Project's description"
    param :created_at, Date, "Project's time of creation", allow_nil: false
    param :updated_at, Date, "Project's time of edition", allow_nil: false
    param :user_id, :number, "User's id of project's owner"
    param :is_project_from_github, :boolean, "Verify if project is from a github account"
    param :is_scoring, :boolean, "Verify if project counts story points"
  end

  api :GET, "/users/:user_id/projects", "Show projects for an user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all projects of a specific user"
  returns code: 200, desc: "Ok" do
    param_group :project
  end
  example <<-EOS
  [
      {
      "id":1,
      "name":"Owla",
      "description":"This project helps improving classes",
      "created_at":"2019-04-11T15:42:34.013Z",
      "updated_at":"2019-04-11T15:42:34.013Z",
      "user_id":1,
      "github_slug":null,
      "is_project_from_github":true,
      "is_scoring":true
      },
      {
      "id":2,
      "name":"Falko",
      "description":"This project helps agile projects",
      "created_at":"2019-04-11T15:42:34.044Z",
      "updated_at":"2019-04-11T15:42:34.044Z",
      "user_id":1,
      "github_slug":null,
      "is_project_from_github":true,
      "is_scoring":true
      }
  ]
  EOS
  def index
  end

  api :GET, "/repos", "Show a github projects list"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a projects list of current user from github"
  returns code: 200, desc: "Ok" do
    param_group :project
  end
  def github_projects_list
  end

  api :GET, "/projects/:id", "Show a specific project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  returns code: 200, desc: "Ok" do
    param_group :project
  end
  example <<-EOS
  {
      "id":1,
      "name":"Owla",
      "description":"This project helps improving classes",
      "created_at":"2019-04-11T15:42:34.013Z",
      "updated_at":"2019-04-11T15:42:34.013Z",
      "user_id":1,
      "github_slug":null,
      "is_project_from_github":true,
      "is_scoring":true
  }
  EOS
  def show
  end

  api :POST, "/users/:user_id/projects", "Create a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create project for a specific user"
  param_group :project
  def create
  end

  api :PATCH, "/projects/:id", "Update a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update project for a specific user"
  param_group :project
  def update
  end

  api :DELETE, "/projects/:id", "Delete a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete project for a specific user"
  param_group :project
  def destroy
  end
end
