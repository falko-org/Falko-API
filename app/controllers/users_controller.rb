require "rest-client"
class UsersController < ApplicationController
  include ValidationsHelper
  include UsersDoc

  skip_before_action :authenticate_request, only: [:create, :all]

  before_action only: [:show, :update, :destroy] do
    set_user
    validate_user(:id, 0)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id].to_i)
    render json: @user
  end

  # POST /users V1
  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     @token = AuthenticateUser.call(@user.email, @user.password)

  #     @result = { token: @token.result }

  #     response.set_header("auth_token", @token.result)
  #     render json: @result, status: :created
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  # POST /users V2
  def create
    @user = User.new(user_params)
    if @user.save
      @token = GenerateVerifyToken.call(@user.id)
      UserMailer.with(user: @user).verify_email.deliver_now!
      render json: @token, status: :created
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
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
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
