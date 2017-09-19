class UsersController < ApplicationController
skip_before_action :authenticate_request, only: [:create, :all]
before_action :authenticate_member, :set_user, only: [:show, :update, :destroy]

  def index
    @user = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to home_path @user

      send_notification("first_notification", nil)
    else
      flash[:alert] = "user not created"
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :github)
  end

end
