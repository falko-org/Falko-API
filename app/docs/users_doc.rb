module UsersDoc
  extend Apipie::DSL::Concern

  def_param_group :user do
    param :name, String, "User' name"
    param :email, String, "User's email"
    param :password_digest, String, "User's password"
    param :created_at, Date, "User's time of creation", allow_nil: false
    param :updated_at, Date, "User's time of edition", allow_nil: false
    param :description, String, "User's acess token"
  end

  api :GET, "/users/:id", "Show a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Show a specific user"
  returns code: 200, desc: "Ok" do
    param_group :user
  end
  example <<-EOS
  {
      "id": 1,
      "name": "Vitor Barbosa",
      "email": "barbosa@gmail.com",
      "password_digest": "$2a$10$GDiOPE7a2YMzhaOdgW88NOecH3.eiBLcCZQjDjoi2ykrAdgreV2ge",
      "created_at": "2019-04-11T15:42:33.741Z",
      "updated_at": "2019-04-11T15:42:33.741Z",
      "access_token": null
  }
  EOS
  def show
  end

  api :POST, "/users", "Create a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create a specific user"
  param_group :user
  def create
  end

  api :PATCH, "/users/:id", "Update a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update a specific user"
  param_group :user
  def update
  end

  api :DELETE, "/users/:id", "Delete a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete a specific user"
  param_group :user
  def destroy
  end
end
