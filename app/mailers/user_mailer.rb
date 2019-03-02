class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]

    mail(to: @user.email, subject: 'Welcome to my web app!')
  end

  def reset_password
    @user               = params[:user]
    @token              = params[:token]
    @reset_password_url = edit_password_url(reset_password_token: @token)

    mail(to: @user.email, subject: 'Request to reset your password')
  end
end
