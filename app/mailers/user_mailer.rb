class UserMailer < ApplicationMailer
  default from: "noreply@falko.com"

  def recover_password_email
    @user = params[:user]
    @uri = ENV["RECOVERY_EMAIL_URI"].gsub(/<token>/, @user.reset_password_token)
    mail(to: @user.email, subject: "Falko password recovery")
  end
end
