class UserMailer < ApplicationMailer
  default from: "noreply@falko.com"

  def recover_password_email
    @user = params[:user]
    @uri = ENV["PASSWORD_RESET_ADDRESS"].gsub(/<token>/, @user.reset_password_token)
    mail(to: @user.email, subject: "Falko password recovery")
  end

  def verify_email
    @email = params[:email]
    @token = params[:token]
    # @url
  end
end
