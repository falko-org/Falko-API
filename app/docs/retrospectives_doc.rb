module RetrospectivesDoc
  extend Apipie::DSL::Concern

  def_param_group :retrospective do
    param :sprint_report, String, "Sprint reports"
    param :positive_points, Array, of: String, desc: "Sprint positive points", default_value: []
    param :negative_points, Array, of: String, desc: "Sprint negative points", default_value: []
    param :improvements, Array, of: String, desc: "Sprint improvements", default_value: []
    param :created_at, Date, "Sprint's time of creation", allow_nil: false
    param :updated_at, Date, "Sprint's time of edition", allow_nil: false
    param :sprint_id, :number, "Sprint's id"
  end

  api :GET, "/sprints/:sprint_id/retrospectives", "Show retrospectives for a sprint"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show all retrospectives of a specific sprint"
  returns code: 200, desc: "Ok" do
    param_group :retrospective
  end
  example <<-EOS
  {
      "id": 1,
      "sprint_report": "Sprint 1",
      "positive_points": [
          "Very good"
      ],
      "negative_points": [
          "No tests"
      ],
      "improvements": [
          "Improve front-end"
      ],
      "created_at": "2019-04-11T15:42:36.102Z",
      "updated_at": "2019-04-11T15:42:36.102Z",
      "sprint_id": 1
  }
  EOS
  def index
  end

  api :POST, "/sprints/:sprint_id/retrospectives", "Create a retrospective"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create retrospective of a specific sprint"
  param_group :retrospective
  def create
  end

  api :GET, "/retrospectives/:id", "Show a retrospective"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a specific retrospective of a sprint"
  returns code: 200, desc: "Ok" do
    param_group :retrospective
  end
  example <<-EOS
  {
      "id": 1,
      "sprint_report": "Sprint 1",
      "positive_points": [
          "Very good"
      ],
      "negative_points": [
          "No tests"
      ],
      "improvements": [
          "Improve front-end"
      ],
      "created_at": "2019-04-11T15:42:36.102Z",
      "updated_at": "2019-04-11T15:42:36.102Z",
      "sprint_id": 1
  }
  EOS
  def show
  end

  api :PATCH, "/retrospectives/:id", "Update a retrospective"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update retrospective of a specific sprint"
  param_group :retrospective
  def update
  end

  api :DELETE, "/retrospectives/:id", "Delete a retrospective"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete retrospective of a specific sprint"
  param_group :retrospective
  def destroy
  end
end
