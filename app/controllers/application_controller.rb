class ApplicationController < ActionController::Base
  include ActAsAuthorizable

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def authenticate_user!
    unless current_user
      redirect_to registration_path, alert: 'You must be logged in to access this page.'
    end
  end
end
