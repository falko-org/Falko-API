module GradesDoc
  extend Apipie::DSL::Concern

  def_param_group :grade do
    param :weight_burndown, Float, "Grade's weight of burndown"
    param :weight_velocity, Float, "Grade's weight of velocity"
    param :weight_debts, Float, "Grade's weight of debts"
    param :created_at, Date, "Grade's time of creation", allow_nil: false
    param :updated_at, Date, "Grade's time of edition", allow_nil: false
    param :project_id, :number, "Project's id"
  end

  api :GET, "/projects/:project_id/grades", "Show grades for a project"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all projects of a specific user"
  returns code: 200, desc: "Ok" do
    param_group :grade
  end
  example <<-EOS
  {
      "id": 1,
      "weight_burndown": 1,
      "weight_velocity": 1,
      "weight_debts": 1,
      "created_at": "2019-04-27T19:20:21.581Z",
      "updated_at": "2019-04-27T19:20:21.581Z",
      "project_id": 1
  }
  EOS
  def index
  end

  api :POST, "/projects/:project_id/grades", "Create a new grade"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create grade for a specific project"
  param_group :grade
  def create
  end

  api :PATCH, "/grades/:id", "Update a grade"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update a created grade"
  param_group :grade
  def update
  end

  api :GET, "/grades/:id", "Show a grade"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a specific grade"
  returns code: 200, desc: "Ok" do
    param_group :grade
  end
  def show
  end

  api :DELETE, "/grades/:id", "Delete a grade"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete a specific grade"
  param_group :grade
  def destroy
  end
end
