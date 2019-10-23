class UserMailer < ApplicationMailer
  default from: "noreply@falko.com"
  layout "verify_email"

  def recover_password_email
    @user = params[:user]
    @uri = ENV["PASSWORD_RESET_ADDRESS"].gsub(/<token>/, @user.reset_password_token)
    mail(to: @user.email, subject: "Falko password recovery")
  end

  def verify_email
    # @email = params[:email]
    # @token = params[:token]
    @user = params[:user]
    # puts "user = ", user[:email]
    @email = @user[:email]
    userToken = params[:token]
    @token = userToken.result
    # puts "user = ", email
    # @url
    puts "token = ", @token
    mail to: @email, subject: "Email confirmation token"
  end
end
