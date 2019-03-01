class UsersController < BaseController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user            = current_user
    @user.attributes = user_params

    if @user.save
      redirect_to profile_path, notice: 'Profile updated successfully!'
    else
      redirect_to profile_path, alert: @user.errors.to_a.join(', ')
    end
  end

  private

  def user_email
    params[:user][:email]
  end

  def user_params
    @user_params ||= params.require(:user).permit(:name, :password, :password_confirmation)

    @user_params.reject { |_, v| v.blank? }
  end
end
