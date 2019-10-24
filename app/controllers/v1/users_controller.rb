require "rest-client"
class V1::UsersController < ApplicationController
  include ValidationsHelper
  include UsersDoc

  skip_before_action :authenticate_request, only: [:create, :all]

  before_action only: [:show, :update, :destroy] do
    set_user
    validate_user(:id, 0)
  end

  # POST /users 
  def create
    @user = User.new(user_params)
    if @user.save
      @token = GenerateVerifyToken.call(@user.id)
      UserMailer.with(user: @user, token: @token).verify_email.deliver_now!
      render json: @token, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
