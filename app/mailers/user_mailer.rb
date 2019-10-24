class UserMailer < ApplicationMailer
  default from: "noreply@falko.com"
  layout "verify_email"

  def recover_password_email
    @user = params[:user]
    @uri = ENV["PASSWORD_RESET_ADDRESS"].gsub(/<token>/, @user.reset_password_token)
    mail(to: @user.email, subject: "Falko password recovery")
  end

  def verify_email
    @user = params[:user]
    @email = @user[:email]
    user_token = params[:token]
    @token = user_token.result
    mail to: @email, subject: "Email confirmation token"
  end
end
