class RegistrationsController < BaseController
  before_action :redirect_if_authenticated!

  def new
    @user = User.new
  end

  def create
    user_form = UserForm.new(user_params)

    if user_form.save
      sign_in(user_form.user)

      redirect_to profile_path, notice: 'Account created successfully!'
    else
      redirect_to registration_path, alert: user_form.errors.to_a.join(', ')
    end
  end

  private

  def redirect_if_authenticated!
    redirect_to profile_path if current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
