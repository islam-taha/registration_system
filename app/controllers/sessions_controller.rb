class SessionsController < BaseController
  before_action :redirect_if_authenticated!, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user.present? && @user.authenticate(user_params[:password])
      sign_in(@user)

      redirect_to profile_path, notice: 'Logged in successfully!'
    else
      redirect_to session_path, alert: 'Incorrect email or password, please try again later'
    end
  end

  def destroy
    sign_out

    redirect_to session_path, notice: 'Logged out successfully!'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
