class PasswordsController < ApplicationController
  skip_before_action :authenticate_request

  def forgot
    if password_params[:email].blank?
      return render json: { error: "Email not present" }, status: :bad_request
    end

    user = User.find_by(email: password_params[:email].downcase)

    if user.present?
      user.generate_password_token!
      UserMailer.with(user: user).recover_password_email.deliver_now
      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "ok" }, status: :ok
    end
  end

  def reset
    if password_params[:token].blank?
      return render json: { error: "Token not present" } , status: :bad_request
    end

    token = password_params[:token].to_s

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(password_params[:password])
        render json: { status: "ok" }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ["Link not valid or expired. Try generating a new one."] }, status: :not_found
    end
  end


  private

    def password_params
      params.permit(:email, :token, :password)
    end
end
