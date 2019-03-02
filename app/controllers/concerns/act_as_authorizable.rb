module ActAsAuthorizable
  UNAUTHORIZED_ALERT = 'You must be logged in to access this page.'.freeze

  def sign_in(user)
    session[:user_id]             = user.id
    cookies.permanent[:signed_in] = true
  end

  def sign_out
    session[:user_id] = nil
  end

  def signed_in_before?
    cookies.permanent[:signed_in]
  end
end
