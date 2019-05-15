module ReleasesDoc
  extend Apipie::DSL::Concern

  def_param_group :release do
    param :name, String, "Release's name"
    param :description, String, "Release's description"
    param :amount_of_sprints, Integer, "Release's number of sprints"
    param :created_at, Date, "Release's time of creation", allow_nil: false
    param :updated_at, Date, "Release's time of edition", allow_nil: false
    param :project_id, :number, "Project's id"
    param :initial_date, Date, "Release's initial date"
    param :final_date, Date, "Release's final date"
  end

  api :GET, "/projects/:project_id/releases", "Show releases for a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all releases of a specific project"
  returns code: 200, desc: "Ok" do
    param_group :release
  end
  example <<-EOS
  [
    {
        "id": 2,
        "name": "R2",
        "description": "Agile Release",
        "amount_of_sprints": 0,
        "created_at": "2019-04-11T15:42:34.118Z",
        "updated_at": "2019-04-27T20:55:28.228Z",
        "project_id": 1,
        "initial_date": "2016-01-01",
        "final_date": "2016-12-01"
    },
    {
        "id": 1,
        "name": "R1",
        "description": "RUP Release",
        "amount_of_sprints": 2,
        "created_at": "2019-04-11T15:42:34.101Z",
        "updated_at": "2019-04-27T20:55:28.231Z",
        "project_id": 1,
        "initial_date": "2016-01-01",
        "final_date": "2016-10-01"
    }
  ]
  EOS
  def index
  end

  api :GET, "releases/:id", "Show a release for a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a specific release of a project"
  returns code: 200, desc: "Ok" do
    param_group :release
  end
  example <<-EOS
  {
    "project_id": 1,
    "id": 1,
    "amount_of_sprints": 2,
    "name": "R1",
    "description": "RUP Release",
    "initial_date": "2016-01-01",
    "final_date": "2016-10-01",
    "created_at": "2019-04-11T15:42:34.101Z",
    "updated_at": "2019-04-27T20:55:28.231Z"
  }
  EOS
  def show
  end

  api :POST, "/projects/:project_id/releases", "Create a release"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create release of a project"
  param_group :release
  def create
  end

  api :PATCH, "/releases/:id", "Update a release"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update release of a project"
  param_group :release
  def update
  end

  api :DELETE, "/releases/:id", "Delete a release"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete release of a project"
  param_group :release
  def destroy
  end
end
