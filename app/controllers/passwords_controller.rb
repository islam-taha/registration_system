class PasswordsController < ApplicationController
  before_action :redirect_if_no_token, only: :edit

  def new
    @user = User.new
  end

  def create
    @user = send_reset_password_token_info

    if @user
      redirect_to password_path, notice: 'Reset password instructions sent successfully!'
    else
      redirect_to password_path, alert: 'No user found with this email!'
    end
  end

  def edit
    @user = User.new
  end

  def update
    @user = reset_password_by_token

    if @user.token_not_expired_and_reset_success?(user_params)
      sign_in(@user)

      redirect_to profile_path, notice: 'Password resetted successfully!'
    else
      redirect_to edit_password_path(reset_password_token: user_params[:reset_password_token]),
                  alert: @user.errors.to_a.join(', ')
    end
  end

  private

  def blank_token
    params[:reset_password_token].blank?
  end

  def redirect_if_no_token
    redirect_to session_path, alert: 'No password token found!' if blank_token
  end

  def send_reset_password_token_info
    user = User.find_by(email: user_params[:email])

    if user
      user.send_reset_password_token_info
    else
      false
    end
  end

  def reset_password_token_by_pub_key
    Users::Passwords.digest(:reset_password_token, user_params[:reset_password_token])
  end

  def reset_password_by_token
    User.find_by(reset_password_token: reset_password_token_by_pub_key)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
