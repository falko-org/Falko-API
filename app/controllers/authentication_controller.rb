class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      user = User.find_by_email params[:email]
      render json: { auth_token: command.result, user: user.as_json(only: [:id, :name, :email]) }
    else
      render json: { error: command.errors } , status: :unauthorized
    end
  end

  def confirm_email
    begin
      token = params[:token]
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      current_user = User.find(decoded_token["user_id"])
      email = current_user.email
      current_user.confirmation_token = true
      current_user.save
      render json: { status: 200, message: "User confirmed" }.to_json
    rescue JWT::DecodeError => e
      render json: { status: 401, message: "Invalid token" }.to_json
    end    
  end


end
