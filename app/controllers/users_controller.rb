require "rest-client"
class UsersController < ApplicationController
  include ValidationsHelper

  skip_before_action :authenticate_request, only: [:create, :all]

  before_action only: [:show, :update, :destroy] do
    set_user
    validate_user(:id, 0)
  end

  def_param_group :user do
    param :name, String, "User' name"
    param :email, String, "User's email"
    param :password_digest, String, "User's password"
    param :created_at, Date, "User's time of creation", allow_nil: false
    param :updated_at, Date, "User's time of edition", allow_nil: false
    param :description, String, "User's acess token"
  end

  # GET /users/1
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
    @user = User.find(params[:id].to_i)
    render json: @user
  end

  # POST /users
  api :POST, "/users", "Create a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Create a specific user"
  param_group :user
  def create
    @user = User.new(user_params)
    if @user.save
      @token = AuthenticateUser.call(@user.email, @user.password)

      @result = { token: @token.result }

      response.set_header("auth_token", @token.result)
      render json: @result, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def request_github_token
    code_token = params[:code]

    result = RestClient.post(
      "https://github.com/login/oauth/access_token",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"],
      code: code_token,
      accept: :json
    )


    access_token = result.split("&")[0].split("=")[1]

    unless access_token == "bad_verification_code" || access_token == nil
      @user = User.find(params[:id])
      @user.access_token = access_token

      if @user.update_column(:access_token, access_token)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: result, status: :bad_request
    end
  end

  def remove_github_token
    @user = User.find(params[:id])
    @user.access_token = nil
    if @user.update_column(:access_token, nil)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  api :PATCH, "/users/:id", "Update a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Update a specific user"
  param_group :user
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  api :DELETE, "/users/:id", "Delete a user"
  error code: 401, desc: "Unauthorized"
  error code: 404, desc: "Not Found"
  error code: 500, desc: "Internal Server Error"
  description "Delete a specific user"
  param_group :user
  def destroy
    @user.destroy
    render json: { status: 200, message: "User deleted successfully" }.to_json
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
