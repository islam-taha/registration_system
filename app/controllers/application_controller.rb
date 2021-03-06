class ApplicationController < ActionController::Base
  include ActAsAuthorizable

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def authenticate_user!
    return if current_user

    if signed_in_before?
      redirect_to session_path,      alert: UNAUTHORIZED_ALERT
    else
      redirect_to registration_path, alert: UNAUTHORIZED_ALERT
    end
  end

  def redirect_if_authenticated!
    redirect_to profile_path if current_user
  end
end
