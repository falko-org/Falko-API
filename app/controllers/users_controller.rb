require 'rest-client'
class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :all, :request_github_token]
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  def all
    @users = User.all.order('id ASC')
    render :index
  end

  # GET /users/1
  def show
    if validate_user
      @user = User.find(params[:id].to_i)
      render json: @user
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      @token = AuthenticateUser.call(@user.email, @user.password)

      @result = { token:@token.result }

      response.set_header("auth_token", @token.result)
      render json: @result, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def request_github_token
    code_token = params[:code]
    result = RestClient.post('https://github.com/login/oauth/access_token',
      {:client_id => 'cbd5f91719282354f09b',
       :client_secret => '634dd13c943b8196d4345334031c43d6d5a75fc8',
       :code => code_token,
       :accept => :json
      })


    access_token = result.split('&')[0].split('=')[1]

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

  # PATCH/PUT /users/1
  def update
    if validate_user
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # DELETE /users/1
  def destroy
    if validate_user
      @user.destroy
      redirect_to action: 'index', status:200
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :github)
  end

  def validate_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
    @current_user.id == (params[:id]).to_i
  end

end
